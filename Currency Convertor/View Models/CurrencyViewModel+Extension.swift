//
//  CurrencyViewModel+Extension.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 16/08/21.
//

import Foundation

//Web service related extesnions

extension CurrencyListViewModel {
    
    
    func currencyViewModelForCountryCode(countryCode: String, sourceCountryCode: String) -> CurrencyViewModel! {
        
        
        let countries = self.currencyViewModels.filter { currencyVM in
            
            let actualCountryCodeKey = sourceCountryCode + (currencyVM.currencyCode ?? "")
            return actualCountryCodeKey == countryCode ? true : false
            
        }
        
        if countries.count > 0 {
            
            return countries[0]
        } else {
            
            //create a custom vm and default values
            return CurrencyViewModel(currencyCode: countryCode, country: countryCode)  }
    }
    
    
    func loadLiveCurrencyExchangeRates() {
        
        let liveExchangeRateUrl = Constants.urlForLiveExchangeRate()
        let resource = Resource<CurrencyExchangeResponse>.init(url: liveExchangeRateUrl) { data in
            
            if let liveRates = try? JSONDecoder().decode(CurrencyExchangeResponse.self, from: data) {
                return liveRates
            }
            return nil
        }
        
        Webservice().load(resource: resource) { [weak self] result in
            
            self?.showProgressBar?(true)
            
            if let result = result {
                if result.success == true {
                    
                    let models = result.quotes ?? [:]
                    self?.currencyViewModels = models.map { model in
                        
                        let currencyVM = self?.currencyViewModelForCountryCode(countryCode: model.key, sourceCountryCode: result.source ?? "")
                        
                        currencyVM?.usdExchangeRate = model.value
                        return currencyVM!
                        
                    }
                    
                    DispatchQueue.main.async {
                        if let exhangeRatesDidLoad = self?.exhangeRatesDidLoad {
                            
                            DispatchQueue.main.async {
                                self?.showProgressBar?(false)
                            }

                            exhangeRatesDidLoad()
                        }
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        self?.showProgressBar?(false)

                        self?.showAlertOnUI?("You have consumed your monthly quota or Unknown error occured. Please check after some time!".localized)
                    }
                }
            }
        }
    }
    
    
    
    func loadCourencyList() {
        
        let listOfExchangesUrl = Constants.urlForListOfExchanges()
        let resource = Resource<CurrencyListResponse>.init(url: listOfExchangesUrl) { data in
            
            if let currencies = try? JSONDecoder().decode(CurrencyListResponse.self, from: data) {
                return currencies
            }
            
            DispatchQueue.main.async {
                self.showProgressBar?(false)
            }

            return nil
        }
        
        
        DispatchQueue.main.async {
            
            self.showProgressBar?(true)
        }

        Webservice().load(resource: resource) { [weak self] result in
            
            if let result = result {
                if result.success == true {
                    
                    //Create models for supported countries
                    let models = result.currencies ?? [:]
                    self?.currencyViewModels = models.map { CurrencyViewModel(currencyCode: $0.key, country: $0.value)  }
                    
                    //Load the live rate of exchange
                    self?.loadLiveCurrencyExchangeRates()
                }
            } else {
                
                DispatchQueue.main.async {
                    
                    self?.showProgressBar?(false)
                    self?.showAlertOnUI?("You have consumed your monthly quota or Unknown error occured. Please check after some time!".localized)
                }
                
            }
        }
    }
    
}
