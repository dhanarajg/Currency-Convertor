//
//  CurrencyConvertorViewController.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation
import UIKit
import iOSDropDown
import ProgressHUD

class CurrencyConvertorViewController: UIViewController {
    
    @IBOutlet weak var currencyAmountTextField: UITextField!
    @IBOutlet weak var exchangeRatesCollectionView: UICollectionView!
    @IBOutlet weak var currencySelectionTextField: DropDown!
    
    let currencyListViewModel = CurrencyListViewModel()
    var selectedCountryCode: String = "USD"
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setUp()
    }
    
    
    @IBAction func reloadTapped(_ sender: Any) {
        
        currencyListViewModel.loadExchangeData()
    }
    
    
    //load from server and other configs
    func setUp() {
        
        self.addDoneButtonOnKeyboard(textField: currencyAmountTextField, keyboardDoneCallback: #selector(currencyAmountDoneTapped))
        currencyAmountTextField.addTarget(self, action: #selector(currencyAmountTextFieldDidChange), for: .editingChanged)
        
        currencySelectionTextField.didSelect { [weak self] title, index, id in
            self?.currencyDidSelect(countrycode: title, index: index)
        }
        
        currencyListViewModel.loadExchangeData()
        currencyListViewModel.showAlertOnUI = showAlertOnUI
        currencyListViewModel.exhangeRatesDidLoad = exhangeRatesDidLoad
        currencyListViewModel.showProgressBar = showProgressBar
    }
    
    @objc func currencyAmountTextFieldDidChange() {
        
        self.exchangeRatesCollectionView.reloadData()
    }
    
    //country changed.. reload
    func currencyDidSelect(countrycode: String, index: Int) {
        
        self.selectedCountryCode = self.currencyListViewModel.currencyCodeForIndex(index: index)
        self.exchangeRatesCollectionView.reloadData()
    }
    
    
    //done button on keyoard added
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
    
    //amount changed.. reload
    @objc func currencyAmountDoneTapped() {
        currencyAmountTextField.resignFirstResponder()
        self.exchangeRatesCollectionView.reloadData()
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
        
        if true == updatedText.isEmpty {
            return true
        }
        
        return false
    }
}



extension CurrencyConvertorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currencyListViewModel.numberOfExchanges()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExchangeRateCollectionViewCell", for: indexPath) as? ExchangeRateCollectionViewCell else {
            fatalError("ExchangeRateCollectionViewCell not found!")
        }
        
        let currencyAmount = Double(currencyAmountTextField.text ?? "0") ?? 0

       let exchangeCellVM =  self.currencyListViewModel.curreencyCellViewModelFor(amountToConvert: currencyAmount, selectedCountryCode: self.selectedCountryCode, index: indexPath.row)
                
        cell.countryLabel.text = exchangeCellVM.currencyCode
        cell.exhangeAmountLabel.text = String(format: "%.2f", exchangeCellVM.exchangeAmount)
        cell.rateLabel.text = String(format: "%.2f", exchangeCellVM.exchangeRate)
        
        return cell
    }
    
}


extension CurrencyConvertorViewController: CurrencyListViewModelDelegate {
    
    func showAlertOnUI(message: String) {
        
        let alert = UIAlertController.init(title: "Alert!".localized, message: message.localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK".localized, style: .cancel) )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func exhangeRatesDidLoad() {
        
        let currencyListDisplayNames = currencyListViewModel.currencyListDisplayNames()
        self.currencySelectionTextField.optionArray = currencyListDisplayNames
        
        self.currencySelectionTextField.selectedIndex = 0
        self.currencySelectionTextField.text = currencyListDisplayNames[0]
        self.currencyDidSelect(countrycode: currencyListDisplayNames[0], index: 0)
    }
    
    
    func showProgressBar(show: Bool) {
        
        if show {
            ProgressHUD.animationType = .circleRotateChase
            ProgressHUD.show()
        } else {
            ProgressHUD.dismiss()
        }
    }
}
