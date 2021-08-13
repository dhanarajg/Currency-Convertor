//
//  Constants.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation


private let ACCESS_KEY = "36026942ea8967232f3e47514a02f09b"
private let BASE_URL = "https://api.currencylayer.com"

struct Constants {
    
    
    static func urlForListOfExchanges() -> URL {
        
        let url = "\(BASE_URL)/list?\(ACCESS_KEY.escaped())"
        return URL(string: url)!
    }
    
    static func urlForLiveExchangeRate() -> URL {
        
        let url = "\(BASE_URL)/live?\(ACCESS_KEY.escaped())"
        return URL(string: url)!
    }

}



