//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    
    
    
    var coinManager = CoinManager()
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var coinPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinPicker.delegate = self
        coinPicker.dataSource = self
        
        // Set the picker view's frame (position and size)
        //coinPicker.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        view.addSubview(coinPicker)
        coinManager.delegate = self
    }
    
    
}
extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return items[row] // The title for each row
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedItem = coinManager.currencyArray[row]
        coinManager.fetchD(name: selectedItem)
    }
    
}
extension ViewController: CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, price: CoinModel) {
        DispatchQueue.main.async { // Ensure this runs on the main thread
            self.priceLabel.text = String(price.price)
        }
    }
    
    func didFailWithError(error: Error) { // Fixed the error type to Error
        print(error)
    }
}

