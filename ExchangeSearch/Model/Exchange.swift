//
//  ExchangeManager.swift
//  ExchangeSearch
//
//  Created by Jędrzej Kuś on 22/02/2022.
//

import Foundation

struct Exchanges: Decodable {
    let effectiveDate: String
    let rates: [Rates]
}

struct Rates: Decodable {
    let currency: String
    let code: String
    let mid: Float
}
