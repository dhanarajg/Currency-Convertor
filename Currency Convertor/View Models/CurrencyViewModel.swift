//
//  CurrencyViewModel.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation
import Reachability


class CurrencyListViewModel: NSObject {
    
    var currencyViewModels = [CurrencyViewModel]()
    var showAlertOnUI: ((String) -> Void)?
    var reloadExhangeRates: (() -> Void)?
    
    var timer: Timer?
    
    var currencyList: [String] {
        
        let currencylist = currencyViewModels.map { currencyVM in
            return (currencyVM.country ?? "") + (currencyVM.currencyCode ?? "")
        }
        return currencylist
    }
    
    
    private func loadCourrencyList() {
        
        let url = Constants.urlForListOfExchanges()
        let resource = Resource<CurrencyListResponse>.init(url: url) { data in
            
            if let currencies = try? JSONDecoder().decode(CurrencyListResponse.self, from: data) {
                return currencies
            }
            return nil
        }
        
        
        Webservice().load(resource: resource) { [weak self] result in
            
            if let result = result {
                if result.success == true {
                    
                    let models = result.currencies ?? [:]
                    self?.currencyViewModels = models.map { CurrencyViewModel(currencyCode: $0.key, country: $0.value)  }
                    
                    DispatchQueue.main.async {
                        if let reloadExhangeRates = self?.reloadExhangeRates {
                            reloadExhangeRates()
                        }
                    }
                }
            } else {
                
                DispatchQueue.main.async {
                    self?.showAlertOnUI?("You have consumed your monthly quota or Unknown error occured. Please check after some time!".localized)
                }
                
            }
        }
        
    }
    
    private func loadCurrencyExchangeRates() {
        
    }
    
    
    func loadExchangeData () {
        
        let reachability = try! Reachability()
        
        if (reachability.connection == .unavailable) {
            
            self.showAlertOnUI?("Please check your internet connection!".localized)
            return
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 60*30, repeats: true) { [weak self] timer in
            
            self?.loadCourrencyList()
            self?.loadCurrencyExchangeRates()
            
        }
        
    }
}



class CurrencyViewModel: NSObject {
    
    let country: String?
    let currencyCode: String?
    var usdExchangeRate: Double = 0
    
    init (currencyCode: String, country: String) {
        
        self.currencyCode = currencyCode
        self.country = country
    }
    
    func exchangeValue(amount: Double, countryCode: String ) -> Double {
        return usdExchangeRate * amount
    }
    
    
//    var exchangeAmount: Double {
//
//        return 1.0
//    }
}
