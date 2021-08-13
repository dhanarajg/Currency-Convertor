//
//  Currency.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation

struct CurrenciesResponse: Decodable {
    let success: Bool?
    let currencies: [String:String]?
}

