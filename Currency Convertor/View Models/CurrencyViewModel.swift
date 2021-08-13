//
//  CurrencyViewModel.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation


class CurrencyListViewModel: NSObject {
    
    var currencyViewModels = [CurrencyViewModel]()
    
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
                }
            }
            
            
        }
    }



class CurrencyViewModel: NSObject {
    
    let country: String?
    let currencyCode: String?
    
    var exchangeRate: Double = 0

     init (currencyCode: String, country: String) {
        
        self.currencyCode = currencyCode
        self.country = country
    }
}
