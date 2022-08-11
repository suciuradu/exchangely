//
//  Transaction.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import Foundation

struct Transaction: Equatable {
    let fromCurrency: Currency
    let toCurrency: Currency
    let fromAmount: Double
    let toAmount: Double
}
