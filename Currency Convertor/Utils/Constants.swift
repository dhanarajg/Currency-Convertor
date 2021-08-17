//
//  Constants.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation


private let ACCESS_KEY = "e3aea275f2c7552bb739e73b62212b26"
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



