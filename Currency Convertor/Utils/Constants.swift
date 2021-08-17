//
//  Constants.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation


private let ACCESS_KEY = "36026942ea8967232f3e47514a02f09b"
private let BASE_URL = "http://api.currencylayer.com" //http only in free tier

struct Constants {
    
    
    static func urlForListOfExchanges() -> URL {
        
        let url = "\(BASE_URL)/list?access_key=\(ACCESS_KEY.escaped())"
        return URL(string: url)!
    }
    
    static func urlForLiveExchangeRate() -> URL {
        
        let url = "\(BASE_URL)/live?access_key=\(ACCESS_KEY.escaped())"
        return URL(string: url)!
    }
    
}



