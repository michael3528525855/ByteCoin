//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//CA647287-8BDB-4D5F-BBB7-77663975AF40
//GET /v1/exchangerate/BTC?apikey=CA647287-8BDB-4D5F-BBB7-77663975AF40
import Foundation

protocol CoinManagerDelegate{
    func didUpdatePrice(_ coinManager:CoinManager,price :CoinModel)
    func didFailWithError(error: Error)
}


struct CoinManager {
    var delegate : CoinManagerDelegate?
    
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"///USD
    let apiKey = "c2fc277e-2210-415a-ba8e-eaf59c3045d0"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    func fetchD(name:String){
        
        let url = "\(baseURL)/\(name)"
        
        performRequest(with :url)
    }
    func performRequest(with url:String){
        if let url = URL(string: url){
            //-------
            var request = URLRequest(url: url)
            request.addValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
            //-----
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data, Response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                }
                if let saveData = data{
                    if let currencycondetion = parseData(parseWith :saveData){
                        self.delegate?.didUpdatePrice(_coinManager: self, price: currencycondetion)
                    }
                }
            }
            task.resume()
        }
        
    }
    func parseData(parseWith data :Data)->CoinModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try (decoder.decode(CoinData.self, from: data))
            let price = decodedData.rate
            let coinModel = CoinModel(price: price)
            return coinModel
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
