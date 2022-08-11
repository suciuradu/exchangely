//
//  ConvertCurrencyViewModel.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import Foundation
import RxSwift

protocol ConvertCurrencyFlowDelegate: AnyObject {
    func didTapExchange(on viewModel: ConvertCurrencyViewModel)
    func changeExchangeAccount(on viewModel: ConvertCurrencyViewModel)
}

protocol ConvertCurrencyViewModel: AnyObject {
    func didTapExchange()
    func changeExchangeAccount()
    func makeConversion(for amount: Double)
    func updateExchangeAccount(to account: Account)
    
    var updateExchangeAccount: PublishSubject<Bool> { get }
    var amountToBeChanged: PublishSubject<String> { get }
    var currentAccount: Account { get }
    var exchangeAccount: Account { get }
    
    var navigationTitle: String { get }
    var exchangeButtonTitle: String { get }
    
    var currency: String { get }
    var exchagedCurrency: String { get }
    var comissionFee: PublishSubject<Double> { get }
    var comissionDescription: String { get }
}

final class ConvertCurrencyViewModelImpl: ConvertCurrencyViewModel {
    
    // MARK: - Public properties
    
    weak var flowDelegate: ConvertCurrencyFlowDelegate?
    
    var updateExchangeAccount = PublishSubject<Bool>()
    var amountToBeChanged = PublishSubject<String>()
    var navigationTitle: String { "Sell \(currency)"}
    var exchangeButtonTitle: String { "Sell \(currency) to \(exchagedCurrency)" }
    var comissionFee = PublishSubject<Double>()
    var comissionDescription: String {
        isComissionFree ? "This transaction has no added comission! IT'S FREE" : "Comission fee added at final price"
    }
    
    var currency: String { currentAccount.currency.rawValue }
    var exchagedCurrency: String { exchangeAccount.currency.rawValue }
    
    var currentAccount: Account
    var exchangeAccount: Account
    
    // MARK: - Private properties
    
    private let exchangeService: ExchangeService
    private let accountSerivce: AccountService
    
    private var currentAmount: Double = 0
    private var exchangedAmount: Double = 0
    private var isComissionFree: Bool { accountSerivce.isComissionFree }
    
    // MARK: - Init
    
    init(exchangeService: ExchangeService, accountSerivce: AccountService) {
        self.exchangeService = exchangeService
        self.accountSerivce = accountSerivce
        
        currentAccount = accountSerivce.getCurrentAccount()
        exchangeAccount = accountSerivce.getFirstEligibleAccount()
    }
    
    // MARK: - Public Methods
    
    func makeConversion(for amount: Double) {
        exchangeService.exchange(fromCurrency: currency, amount: amount, toCurrency: exchagedCurrency) { [weak self] result in
            switch result {
            case .success(let exchenge):
                guard let self = self else { return }
                guard let exchangedAmount = Double(exchenge.amount) else { return }
                self.currentAmount = amount
                self.exchangedAmount = exchangedAmount.roundTwoDecimals()
                self.amountToBeChanged.onNext(exchenge.amount)
                
                guard !self.isComissionFree else { return }
                let comission = self.accountSerivce.computeComissionFee(for: amount)
                self.comissionFee.onNext(comission.amount.roundTwoDecimals())
            default:
                break
            }
        }
    }
    
    func didTapExchange() {
        let computedComission = accountSerivce.computeComissionFee(for: currentAmount)
        var computedCurrentAmmount = currentAmount
        
        if !computedComission.isFree { computedCurrentAmmount += computedComission.amount }

        accountSerivce.exchange(amount: computedCurrentAmmount,
                                toCurrency: exchangeAccount.currency,
                                exchangedAmount: exchangedAmount)
        flowDelegate?.didTapExchange(on: self)
    }
    
    func changeExchangeAccount() {
        flowDelegate?.changeExchangeAccount(on: self)
    }
    
    func updateExchangeAccount(to account: Account) {
        exchangeAccount = account
        updateExchangeAccount.onNext(true)
    }
}
