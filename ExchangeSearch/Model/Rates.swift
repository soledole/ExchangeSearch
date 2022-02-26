//
//  Rates.swift
//  ExchangeSearch
//
//  Created by Jędrzej Kuś on 26/02/2022.
//

import Foundation

struct Rate: Decodable {
    let rates: [Rates2]
}

struct Rates2: Decodable {
    let effectiveDate: String
    let mid: Float
}
