//
//  String+Extension.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
