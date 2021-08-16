//
//  CurrencyViewModelTests.swift
//  Currency ConvertorTests
//
//  Created by Dhanaraj on 16/08/21.
//

import XCTest
@testable import Currency_Convertor

class CurrencyViewModelTests: XCTestCase {

    private var currencyConvertorListVM: CurrencyListViewModel!
    
    override func setUp() {
        self.currencyConvertorListVM = CurrencyListViewModel()

    }


    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testExample() throws {

    }


    func testCurrencyConversion()  {
        
        let convertedAmount1 = self.currencyConvertorListVM.convertCurrency(amountToConvert: 100, sourceUsdRate: 74, destinationUsdRate: 110)
        XCTAssertEqual(148.64864864864865, convertedAmount1)
        
        
        let convertedAmount2 = self.currencyConvertorListVM.convertCurrency(amountToConvert: 100, sourceUsdRate: 74, destinationUsdRate: 111)
        XCTAssertNotEqual(148.64864864864865, convertedAmount2)

        
    }

}
