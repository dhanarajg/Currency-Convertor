//
//  Constants.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation


private let ACCESS_KEY = "36026942ea8967232f3e47514a02f09b"

struct Constants {
    
    
    static func urlForListOfExchanges() -> URL {
        
        let url = "https://api.currencylayer.com/list?\(ACCESS_KEY.escaped())"
        
        return URL(string: url)!
    }
}



