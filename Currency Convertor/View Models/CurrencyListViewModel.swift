//
//  CurrencyListViewModel.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 16/08/21.
//

import Foundation
import Reachability

protocol CurrencyListViewModelDelegate {
    
    //Implemented can set these variables in ViewModel to get callback
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
        
        //remove existing timer
        self.timer?.invalidate()
        
        //Periodically update live rates (30 minutes)
        self.timer = Timer.scheduledTimer(withTimeInterval: 60*30, repeats: true) { [weak self] timer in
            
            self?.loadCurrencyList()
        }
    }
    
    
    func currencyListDisplayNames() -> [String] {
        
        let list = self.currencyViewModels.map { currencyVM -> String in
            
            let displayname = (currencyVM.currencyName ?? "") + " / " + (currencyVM.currencyCode ?? "")
            return displayname
        }
        
        return list.sorted(by: ({ $0 < $1 }))
    }
    
    func currencyAtIndex(index: Int) -> CurrencyViewModel {
        
        return currencyViewModels[index]
    }
    
    
    func currencyCodeForIndex(index: Int) -> String {
        
        return self.currencyViewModels[index].currencyCode ?? "USD"
    }
    
    
    func convertCurrency(amountToConvert: Double, sourceUsdRate: Double, destinationUsdRate: Double) -> Double {
        
        //logic is to do every calculation in USD.
        //1. convert amount to USD
        //2. multiply it by usd rate to destini usd rate
        let usd = amountToConvert / sourceUsdRate
        let convertedAmount = usd * destinationUsdRate
        return convertedAmount
        
    }
    
    func currencyExchangeAmount (amountToConvert: Double, selectedCountryCode: String, destinationCountryCode: String) -> Double {
        
        let selectedCountryVM = self.currencyViewModelForCountryCode(countryCode: selectedCountryCode, sourceCountryCode: "")
        let destinationVM = self.currencyViewModelForCountryCode(countryCode: destinationCountryCode, sourceCountryCode: "")
        
        let convertedAmount = self.convertCurrency(amountToConvert: amountToConvert, sourceUsdRate: selectedCountryVM?.usdExchangeRate ?? 1, destinationUsdRate: destinationVM?.usdExchangeRate ?? 1)
        return convertedAmount
    }
    
    
    func currencyExchangeRate (selectedCountryCode: String, destinationCountryCode: String) -> Double {
        
        let selectedCountryVM = self.currencyViewModelForCountryCode(countryCode: selectedCountryCode, sourceCountryCode: "")
        let destinationVM = self.currencyViewModelForCountryCode(countryCode: destinationCountryCode, sourceCountryCode: "")
        
        let convertedAmount = self.convertCurrency(amountToConvert: 1, sourceUsdRate: selectedCountryVM?.usdExchangeRate ?? 1, destinationUsdRate: destinationVM?.usdExchangeRate ?? 1)
        return convertedAmount
    }
    
    func curreencyCellViewModelFor(amountToConvert: Double, selectedCountryCode: String, index: Int) -> ExchangeRateCollectionViewCellViewModel {
        
        let currencyVM = self.currencyAtIndex(index:index)
        
        let exchangeAmount = self.currencyExchangeAmount(amountToConvert: amountToConvert, selectedCountryCode: selectedCountryCode , destinationCountryCode: currencyVM.currencyCode ?? "")
        let exchangeRate = self.currencyExchangeRate(selectedCountryCode: selectedCountryCode, destinationCountryCode: currencyVM.currencyCode ?? "")

        
        return ExchangeRateCollectionViewCellViewModel(currencyCode: currencyVM.currencyCode ?? "", exchangeRate: exchangeRate, exchangeAmount: exchangeAmount)
    }

    
    
    func numberOfExchanges() -> Int {
        return self.currencyViewModels.count
    }
}

