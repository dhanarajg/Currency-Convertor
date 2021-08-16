//
//  Currency.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation

struct CurrencyListResponse: Decodable {
    let success: Bool?
    let currencies: [String:String]?
}


struct CurrencyExchangeResponse: Codable {
    let success: Bool?
    let source: String?
    let quotes: [String: Double]?
}
