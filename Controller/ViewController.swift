//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var bitcoin = Bitcoin()
    
    private let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    private let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    private let rest = REST()
    
    //MARK: - IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: Cycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        rest.delegate = self
    }
}

//MARK: - Picker
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let finalURL = baseURL + currencyArray[row]
        rest.loadCurrency(with: finalURL)
    }
}

//MARK: - REST
extension ViewController: ResponseDelegate {
    func didReceiveResponse(bitcoin: Bitcoin) {
        DispatchQueue.main.sync {
            bitcoinPriceLabel.text = String(bitcoin.last)
            dateLabel.text = bitcoin.display_timestamp
        }
    }
}
