//
//  Account.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import Foundation

struct Account: Equatable {
    let currency: Currency
    var balance: Double
    var transactions: [Transaction]
}

