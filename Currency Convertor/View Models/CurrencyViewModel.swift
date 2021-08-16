//
//  CurrencyViewModel.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation
import Reachability

protocol CurrencyListViewModelDelegate {
    
    func showAlertOnUI(message: String)
    func exhangeRatesDidLoad()
    func showProgressBar(show: Bool)
}


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
    
    
    //loads data from server via api
    func loadExchangeData() {
        
        let reachability = try! Reachability()
        
        //No Internet connection
        if (reachability.connection == .unavailable) {
            
            self.showAlertOnUI?("Please check your internet connection!".localized)
            return
        }
        
        //load currency and exchange rates
        self.loadCurrencyList()
        
        //Periodically update live rates (30 minutes)
        self.timer = Timer.scheduledTimer(withTimeInterval: 60*30, repeats: true) { [weak self] timer in
            
            self?.loadCurrencyList()
        }
    }
    
    
    func currencyAtIndex(index: Int) -> CurrencyViewModel {
        
        return currencyViewModels[index]
    }

    
    func currencyCodeForIndex(countryCode: String, index: Int) -> String {

        return self.currencyViewModels[index].currencyCode ?? "USD"
    }
    
    
    //logic is to do every calculation in USD.
    func currencyExchangeAmount (amountToConvert: Double, selectedCountryCode: String, destinationCountryCode: String, index: Int) -> Double {
    
        let selectedCountryVM = self.currencyViewModelForCountryCode(countryCode: selectedCountryCode, sourceCountryCode: "")
        let destinationVM = self.currencyViewModelForCountryCode(countryCode: destinationCountryCode, sourceCountryCode: "")


        //1. convert amount to USD
        //2. multiply it by usd rate to destini usd rate
        let usd = amountToConvert / (selectedCountryVM?.usdExchangeRate ?? 1)
        let convertedAmount = usd * (destinationVM?.usdExchangeRate ?? 1)
        return convertedAmount
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
    
}

