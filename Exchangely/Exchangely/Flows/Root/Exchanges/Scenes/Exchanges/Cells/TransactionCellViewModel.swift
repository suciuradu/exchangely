//
//  TransactionCellViewModel.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import Foundation

struct TransactionCellViewModel {
    
    // MARK: - Public Properties
    
    var currencyText: String {
        "From \(fromCurrency) to \(toCurrency)"
    }
    
    var amountText: String {
        "\(fromAmount) \(fromCurrency) to \(toAmount) \(toCurrency)"
    }
    
    // MARK: - Private properties
    
    private let fromCurrency: String
    private let toCurrency: String
    private let fromAmount: Double
    private let toAmount: Double
    
    // MARK: - Init
    
    init(transaction: Transaction) {
        self.fromCurrency = transaction.fromCurrency.rawValue
        self.toCurrency = transaction.toCurrency.rawValue
        self.fromAmount = transaction.fromAmount
        self.toAmount = transaction.toAmount
    }
}
