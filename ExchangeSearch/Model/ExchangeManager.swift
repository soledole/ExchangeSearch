//
//  ExchangeManager.swift
//  ExchangeSearch
//
//  Created by Jędrzej Kuś on 22/02/2022.
//

import Foundation

struct Exchange {
    let date: String
    let name: String
    let code: String
    let value: Float
}

struct ExchangeManager {
    let ExchangeURL = "http://api.nbp.pl/api/exchangerates/tables/"
    
    func fetchExchange(tableNum: Int) {
        let urlString = "\(ExchangeURL)?fotmat=json"
    }
}
