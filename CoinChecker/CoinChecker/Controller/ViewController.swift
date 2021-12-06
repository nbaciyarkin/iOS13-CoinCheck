//
//  ViewController.swift
//  CoinChecker
//
//  Created by Yarkın Gazibaba on 16.08.2021.
//

import UIKit

class ViewController: UIViewController{
    
    
    @IBOutlet weak var CoinLabel: UILabel!    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var CurrencyTextField: UITextField!
    @IBOutlet weak var coinTextField: UITextField!
    
    
    var coinManager = CoinManager()
    
    var currencyPickerView = UIPickerView()
    var coinPickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        coinTextField.inputView = coinPickerView
        CurrencyTextField.inputView = currencyPickerView
        
        coinPickerView.dataSource = self
        coinPickerView.delegate = self
        currencyPickerView.dataSource = self
        currencyPickerView.delegate = self
        
        
        currencyPickerView.tag = 1
        coinPickerView.tag = 2
        
        coinManager.delegate = self
    }
}

extension ViewController:UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return coinManager.currencyArray.count
        case 2:
            return coinManager.cryptoArray.count
        default:
            return 1
        }
        
      }
      
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag{
        case 1:
            return coinManager.currencyArray[row]
        case 2:
            return coinManager.cryptoArray[row]
        default:
            return "data not found"
        }
      }
      
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag{
        case 1:
            let selectedCurrency = coinManager.currencyArray[row]
            CurrencyTextField.text = selectedCurrency
            CurrencyTextField.resignFirstResponder()
        case 2:
            let selectedCoin = coinManager.cryptoArray[row]
            CoinLabel.text = selectedCoin
            coinTextField.text = selectedCoin
            CoinLabel.resignFirstResponder()
            self.view.endEditing(true)
            
        default:
            return 
        }
                
        coinManager.getCoinPrice(for: CurrencyTextField.text ?? "no Currency ", for: CoinLabel.text ?? "no Coin")
      }
}

extension ViewController: CoinManagerDelegate {
    func didUpdateCoin(price: String, currency: String, coinName: String) {
        DispatchQueue.main.async {
            self.CoinLabel.text = coinName
            self.currencyLabel.text = currency
            self.priceLabel.text = price
        }
    }
    
    
    func didFailedWithError(error: Error) {
        print(error)
    }
}





