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


struct CurrencyValuesResponse: Codable {
    let success: Bool?
    let terms, privacy: String?
    let timestamp: Int?
    let source: String?
    let quotes: [String: Double]?
}
