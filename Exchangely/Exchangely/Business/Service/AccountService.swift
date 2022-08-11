//
//  AccountService.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import Foundation
import RxSwift

enum Currency: String, Equatable {
    case euro = "EUR"
    case ron = "RON"
    case jpy = "JPY"
    case aed = "AED"
    case usd = "USD"
    
    var currencyDescription: String {
        switch self {
        case .euro:
            return "Euro"
        case .ron:
            return "Romanian Leu"
        case .jpy:
            return "Japanese Yen"
        case .aed:
            return "United Arab Emirates Dirham"
        case .usd:
            return "United States Dollar"
        }
    }
}

protocol AccountServiceProtocol: AnyObject {
    var currentAccount: BehaviorSubject<Account> { get }
    var accountsList: [Account] { get }
    var isComissionFree: Bool { get }
    
    func exchange(amount: Double, toCurrency: Currency, exchangedAmount: Double)
    func computeComissionFee(for amount: Double) -> (amount: Double, isFree: Bool)
    
    func getCurrentAccount() -> Account
    func getFirstEligibleAccount() -> Account
    func getExcludedAccountList() -> [Account]
    
    func setNewCurrent(account: Account)
}

final class AccountService: AccountServiceProtocol {
    
    // MARK: - Public Properties
    
    let currentAccount: BehaviorSubject<Account>
    var accountsList: [Account]
    var isComissionFree: Bool { transactionCount == freeComissionCheckCount }
    
    // MARK: - Private Properties
    
    private var account: Account
    private var transactionCount = 0
    
    // MARK: - Constant
    
    private let freeComissionCheckCount = 2
    private let comissionFee = 0.007
    
    // MARK: - Init
    
    init() {
        accountsList = Self.createMockData()
        account = accountsList[0]
        currentAccount = BehaviorSubject(value: account)
    }
    
    // MARK: - Public Methods
    
    func exchange(amount: Double, toCurrency: Currency, exchangedAmount: Double)  {
        guard let index = accountsList.firstIndex(of: account) else { return }
        
        let transaction = Transaction(fromCurrency: account.currency,
                                      toCurrency: toCurrency,
                                      fromAmount: amount,
                                      toAmount: exchangedAmount)
        
        account.balance -= amount
        account.transactions.append(transaction)
        accountsList[index] = account
        
        guard var exchangedAccount = accountsList.first(where: { $0.currency == toCurrency }) else { return }
        guard let index = accountsList.firstIndex(of: exchangedAccount) else { return }
        exchangedAccount.balance += exchangedAmount
        accountsList[index] = exchangedAccount
        
        transactionCount += 1
        currentAccount.onNext(account)
    }
    
    func computeComissionFee(for amount: Double) -> (amount: Double, isFree: Bool) {
        isComissionFree ? (0, true) : (amount * comissionFee, false)
    }
    
    func getCurrentAccount() -> Account { account }
    
    func getExcludedAccountList() -> [Account] {
        var copy = accountsList
        copy.removeAll(where: { $0 == account })
        
        return copy
    }
    
    func getFirstEligibleAccount() -> Account {
        let list = getExcludedAccountList()
        
        return list[0]
    }
    
    func setNewCurrent(account: Account) {
        self.account = account
        currentAccount.onNext(account)
    }
}

extension AccountService {
    
    static func createMockData() -> [Account] {
        [
            Account(currency: .euro, balance: 100, transactions: []),
            Account(currency: .usd, balance: 0, transactions: []),
            Account(currency: .jpy, balance: 0, transactions: []),
            Account(currency: .ron, balance: 0, transactions: []),
            Account(currency: .aed, balance: 0, transactions: [])
        ]
    }
}
