//
//  CurrencyConvertorViewController.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation
import UIKit
import iOSDropDown

class CurrencyConvertorViewController: UIViewController {
    
    @IBOutlet weak var currencyAmountTextField: UITextField!
    @IBOutlet weak var exchangeRatesCollectionView: UICollectionView!
    @IBOutlet weak var currencySelectionTextField: DropDown!
    
    let currencyListViewModel = CurrencyListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addDoneButtonOnKeyboard(textField: currencyAmountTextField, keyboardDoneCallback: #selector(currencyAmountDoneTapped))
        self.loadCurrencies()
    }
    
    
    func loadCurrencies() {
        currencyListViewModel.loadExchangeData()
    }
    
    
    func addDoneButtonOnKeyboard (textField: UITextField, keyboardDoneCallback: Selector?) {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Convert".localized, style: .done, target: self, action: keyboardDoneCallback)
        
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textField.inputAccessoryView = doneToolbar
    }
    
    @objc func currencyAmountDoneTapped() {
        currencyAmountTextField.resignFirstResponder()
    }
}


extension CurrencyConvertorViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return true }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if let _ = Double(updatedText) {
            return true
        }
        
        return false
    }
}



extension CurrencyConvertorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExchangeRateCollectionViewCell", for: indexPath) as? ExchangeRateCollectionViewCell else {
            fatalError("ExchangeRateCollectionViewCell not found!")
        }
        
        let currencyAmount = Double(currencyAmountTextField.text ?? "0") ?? 0
        let countryCode = currencySelectionTextField.text ?? ""
        
        let currency = self.currencyListViewModel.currencyViewModels[indexPath.row]
        cell.countryLabel.text = currency.country
        cell.exhangeAmountLabel.text = String(currency.exchangeValue(amount: currencyAmount, countryCode: countryCode))
        cell.rateLabel.text = String(currency.usdExchangeRate)
        
        return cell
    }
}


extension CurrencyConvertorViewController {
    
    func showAlertOnUI(message: String) {
        
        let alert = UIAlertController.init(title: "Alert!".localized, message: message.localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK".localized, style: .cancel) )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func reloadExhangeRates() {
        
        self.currencySelectionTextField.optionArray = currencyListViewModel.currencyList
        self.exchangeRatesCollectionView.reloadData()
    }
}
