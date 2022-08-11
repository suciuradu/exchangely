//
//  AccountListCellViewModel.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import Foundation

struct AccountListCellViewModel {
    let currency: String
    let currencyDescription: String
    private let balance: Double
    
    var balanceComputed: String { "\(balance.roundTwoDecimals())" + " " + currency}
    
    init(account: Account) {
        self.currency = account.currency.rawValue
        self.currencyDescription = account.currency.currencyDescription
        self.balance = account.balance
    }
}
