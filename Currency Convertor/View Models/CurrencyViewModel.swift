//
//  CurrencyViewModel.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation


class CurrencyViewModel: NSObject {
    
    
    func loadExchangeRates () {
        
        let url = Constants.urlForListOfExchanges()
        let resource = Resource<CurrenciesResponse>.init(url: url) { data in
            
            if let currencies = try? JSONDecoder().decode(CurrenciesResponse.self, from: data) {

                return currencies
            }

            return nil
        }
        
       // Webservice.load(resource)
    }
}
