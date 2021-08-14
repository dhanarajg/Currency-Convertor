//
//  CurrencyViewModel.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation


class CurrencyListViewModel: NSObject {
    
    var currencyViewModels = [CurrencyViewModel]()
    var showAlertOnUI: ((String) -> Void)?
    var reloadExhangeRates: (() -> Void)?
    
    var currencyList: [String] {
     
        let currencylist = currencyViewModels.map { currencyVM in
            return (currencyVM.country ?? "") + (currencyVM.currencyCode ?? "")
        }
        
        return currencylist
    }
    
    
    func loadExchangeRates () {
        
        let url = Constants.urlForListOfExchanges()
        let resource = Resource<CurrenciesResponse>.init(url: url) { data in
            
            if let currencies = try? JSONDecoder().decode(CurrenciesResponse.self, from: data) {
                
                return currencies
            }
            
            return nil
        }
        
        
        Webservice().load(resource: resource) { [weak self] result in
            
            if let result = result {
                if result.success == true {
                    
                    let models = result.currencies ?? [:]
                    self?.currencyViewModels = models.map { CurrencyViewModel(currencyCode: $0.key, country: $0.value)  }
                }
            } else {
                //display error
                self?.showAlertOnUI?("Unknown error occured. Please check after some time!".localized)
            }
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
    
    var exchangeAmount: Double {
        
        return 1.0
    }
    
}
