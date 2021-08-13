//
//  CurrencyConvertorViewController.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation
import UIKit

class CurrencyConvertorViewController: UIViewController {
    
    @IBOutlet weak var currencyAmountTextField: UITextField!
    
    @IBOutlet weak var exchangeRatesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addDoneButtonOnKeyboard(textField: currencyAmountTextField)
    }
    
    
    
    func addDoneButtonOnKeyboard (textField: UITextField) {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Convert".localized, style: .done, target: self, action: #selector(currencyAmountDoneTapped))
        
        

        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textField.inputAccessoryView = doneToolbar
    }
    
    @objc func currencyAmountDoneTapped() {
        currencyAmountTextField.resignFirstResponder()
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
        
        return cell
    }
    
    
}
