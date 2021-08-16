//
//  CurrencyViewModel.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation

class CurrencyViewModel: NSObject {
    
    let currencyName: String? //United Arab Emirates Dirham, Netherlands Antillean Guilder, etc
    let currencyCode: String? //AED, USD, ANG, etc
    
    var usdExchangeRate: Double = 0 //conversion rate 57.8936, 1.269072, etc
    var usdCurrencyCode: String = "" //USDAED, USDAWG, etc
    
    init (currencyCode: String, currencyName: String) {
        
        self.currencyCode = currencyCode
        self.currencyName = currencyName
    }
    
}

