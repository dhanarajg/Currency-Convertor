//
//  CurrencyListViewModel+Extension.swift
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
            
            //create a custom vm with default values
            return CurrencyViewModel(currencyCode: countryCode, currencyName: countryCode)  }
    }
    
    
    func createVMForCurrencyExchangeResponse(result: CurrencyExchangeResponse) {
        
        let models = result.quotes ?? [:]
        self.currencyViewModels = models.map { model in
            
            let currencyVM = self.currencyViewModelForCountryCode(countryCode: model.key, sourceCountryCode: result.source ?? "")
            
            currencyVM?.usdExchangeRate = model.value
            currencyVM?.usdCurrencyCode = model.key
            
            return currencyVM!
        }.sorted(by: ({ $0.currencyName! < $1.currencyName! }))
    }
    
    
    func createVMForCurrencyExchangeListResponse(result: CurrencyListResponse) {
        //Create models for supported countries
        let models = result.currencies ?? [:]
        self.currencyViewModels = models.map { CurrencyViewModel(currencyCode: $0.key, currencyName: $0.value)  }
    }
    
    
    func loadLiveCurrencyExchangeRates() {
        
        let liveExchangeRateUrl = Constants.urlForLiveExchangeRate()
        let resource = Resource<CurrencyExchangeResponse>.init(url: liveExchangeRateUrl) { data in
            
            if let liveRates = try? JSONDecoder().decode(CurrencyExchangeResponse.self, from: data) {
                return liveRates
            }
            return nil
        }
        
        self.showProgressBar?(true)
        
        Webservice().load(resource: resource) { [weak self] result in
            
            switch result {
            
            case .failure(let err):
                var errorMessage = ""
                switch err {
                case .decodingErorr:
                    errorMessage = "Decoding error of Exchange Rates. Please check after some time!".localized
                    
                case .unknownError:
                    errorMessage = "Unknown error of Exchange Rates. Please check after some time!".localized
                }
                
                DispatchQueue.main.async {
                    self?.showProgressBar?(false)
                    self?.showAlertOnUI?(errorMessage)
                }
                
            case .success(let result):
                
                if result.success == true {
                    
                    self?.createVMForCurrencyExchangeResponse(result: result)
                    
                    DispatchQueue.main.async {
                        
                        self?.showProgressBar?(false)
                        self?.exhangeRatesDidLoad?()
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        
                        self?.showProgressBar?(false)
                        self?.showAlertOnUI?("Fetching exchange value failed!. You have consumed your monthly quota or Unknown error occured. Please check after some time!".localized)
                    }
                }
            }
        }
    }
    
    
    
    func loadCurrencyList() {
        
        let listOfExchangesUrl = Constants.urlForListOfExchanges()
        let resource = Resource<CurrencyListResponse>.init(url: listOfExchangesUrl) { data in
            
            if let currencies = try? JSONDecoder().decode(CurrencyListResponse.self, from: data) {
                return currencies
            }
            return nil
        }
        
        
        self.showProgressBar?(true)
        
        Webservice().load(resource: resource) { [weak self] result in
            
            switch result {
            
            case .failure(let err):
                var errorMessage = ""
                switch err {
                case .decodingErorr:
                    errorMessage = "Decoding error of Exchange List. Please check after some time!".localized
                    
                case .unknownError:
                    errorMessage = "Unknown error of Exchange List. Please check after some time!".localized
                }
                
                DispatchQueue.main.async {
                    self?.showProgressBar?(false)
                    self?.showAlertOnUI?(errorMessage)
                }
                
            case .success(let result):
                
                if result.success == true {
                    
                    //Create models for supported countries
                    self?.createVMForCurrencyExchangeListResponse(result: result)
                    
                    //Load the live rate of exchange
                    DispatchQueue.main.async {
                        self?.loadLiveCurrencyExchangeRates()
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        
                        self?.showProgressBar?(false)
                        self?.showAlertOnUI?("Fetching Exchange List failed!. You have consumed your monthly quota or Unknown error occured. Please check after some time!".localized)
                    }
                }
            }
        }
    }    
}
