//
//  MiscTests.swift
//  Currency ConvertorTests
//
//  Created by Dhanaraj on 16/08/21.
//

import XCTest
@testable import Currency_Convertor


class MiscTests: XCTestCase {



    func test_localized() {
        
        let somelocalisedText = "Hello".localized
        
        XCTAssertEqual("Hello", somelocalisedText)
    }

    
    func test_ecaped() {
        
        let escaped = "www.google.com/search?q=hello world".escaped()
        
        XCTAssertEqual("www.google.com%2Fsearch%3Fq=hello%20world", escaped)
    }

}
