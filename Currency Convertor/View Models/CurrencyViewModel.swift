//
//  CurrencyViewModel.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation
import Reachability


class CurrencyListViewModel: NSObject {
    
    var currencyViewModels = [CurrencyViewModel]()
    var showAlertOnUI: ((String) -> Void)?
    var exhangeRatesDidLoad: (() -> Void)?
    var showProgressBar:((Bool) -> Void)?
    
    var timer: Timer?
    
    var currencyList: [String] {
        
        let currencylist = currencyViewModels.map { currencyVM in
            return (currencyVM.country ?? "") + " / " + (currencyVM.currencyCode ?? "")
        }
        
        return currencylist
    }
    
    
    
    func currencyAtIndex(index: Int) -> CurrencyViewModel {
        
        return currencyViewModels[index]
    }
    
    func loadExchangeData() {
        
        let reachability = try! Reachability()
        
        //No Internet connection
        if (reachability.connection == .unavailable) {
            
            self.showAlertOnUI?("Please check your internet connection!".localized)
            return
        }
        
        //load currency and exchange rates
        self.loadCourencyList()

        //Periodically update live rates (30 minutes)
        self.timer = Timer.scheduledTimer(withTimeInterval: 60*30, repeats: true) { [weak self] timer in
            
            self?.loadCourencyList()
        }
    }
    
    
    func currencyCodeForIndex(countryCode: String, index: Int) -> String {
        return self.currencyList[index]
    }
    
    func currencyExchangeRate (countryCode: String) -> Double {
    
        return 100
    }
    
    func numberOfExchanges() -> Int {
        return self.currencyList.count
    }
}



class CurrencyViewModel: NSObject {
    
    let country: String?
    let currencyCode: String?
    var usdExchangeRate: Double = 0
    
    init (currencyCode: String, country: String) {
        
        self.currencyCode = currencyCode
        self.country = country
    }
    
    func exchangeValue(amount: Double, countryCode: String ) -> Double {
        return usdExchangeRate * amount
    }
    
    
//    var exchangeRate: Double {
//
//        return 1.0
//    }
}

