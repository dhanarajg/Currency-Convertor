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
    
    
    let jsonLiveData = """
        {
        "success": true,
        "terms": "https://currencylayer.com/terms",
        "privacy": "https://currencylayer.com/privacy",
        "timestamp": 1430401802,
        "source": "USD",
        "quotes": {
            "USDAED": 3.672982,
            "USDAFN": 57.8936,
            "USDALL": 126.1652,
            "USDAMD": 475.306,
            "USDANG": 1.78952,
            "USDAOA": 109.216875,
            "USDARS": 8.901966,
            "USDAUD": 1.269072,
            "USDAWG": 1.792375,
            "USDAZN": 1.04945,
            "USDBAM": 1.757305,
        }
    }
    """.data(using: .utf8)!

    
    let jsonCurrencyListData = """
    {
       "success":true,
       "terms":"https://currencylayer.com/terms",
       "privacy":"https://currencylayer.com/privacy",
       "currencies":{
          "AED":"United Arab Emirates Dirham",
          "AFN":"Afghan Afghani",
          "ALL":"Albanian Lek",
          "AMD":"Armenian Dram",
          "ANG":"Netherlands Antillean Guilder",
          "AOA":"Angolan Kwanza",
          "ARS":"Argentine Peso",
          "AUD":"Australian Dollar",
          "USD":"United States Dollar"
       }
    }
    """.data(using: .utf8)!

    
    
    override func setUp() {
        super.setUp()
        self.currencyConvertorListVM = CurrencyListViewModel()

    }



    func test_CurrencyConversion()  {
        
        let convertedAmount1 = self.currencyConvertorListVM.convertCurrency(amountToConvert: 100, sourceUsdRate: 74, destinationUsdRate: 110)
        XCTAssertEqual(148.64864864864865, convertedAmount1)
        
        
        let convertedAmount2 = self.currencyConvertorListVM.convertCurrency(amountToConvert: 100, sourceUsdRate: 74, destinationUsdRate: 111)
        XCTAssertNotEqual(148.64864864864865, convertedAmount2)

    }
    
    
    func test_CreateVMForCurrencyExchangeResponse()  {

        XCTAssertNoThrow(try JSONDecoder().decode(CurrencyExchangeResponse.self, from: jsonLiveData))
        
        
        let result = try! JSONDecoder().decode(CurrencyExchangeResponse.self, from: jsonLiveData)
        self.currencyConvertorListVM.createVMForCurrencyExchangeResponse(result: result)
        
        XCTAssertEqual(11, self.currencyConvertorListVM.currencyViewModels.count)
        
        let val =  self.currencyConvertorListVM.currencyViewModelForCountryCode(countryCode: "USDAFN", sourceCountryCode:"")
                
        XCTAssertEqual(57.8936, val?.usdExchangeRate)
    }
    
    
    func test_CurrencyViewModelForCountryCode()  {

        let result = try! JSONDecoder().decode(CurrencyExchangeResponse.self, from: jsonLiveData)
        self.currencyConvertorListVM.createVMForCurrencyExchangeResponse(result: result)
        
        let val =  self.currencyConvertorListVM.currencyViewModelForCountryCode(countryCode: "USDAFN", sourceCountryCode:"")
                
        XCTAssertNotNil(val)
    }

    
    func test_LoadCurrencyListResponseDecoding() {

        XCTAssertNoThrow(try JSONDecoder().decode(CurrencyListResponse.self, from: jsonCurrencyListData))
    }
    
    
    func test_CheckIfTimerRunningAt30MinsInterval() {
        
        self.currencyConvertorListVM.loadExchangeData()
        XCTAssertEqual(30*60, self.currencyConvertorListVM.timer?.timeInterval)
    }

}
