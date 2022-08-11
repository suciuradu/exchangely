//
//  ExchangesViewModel.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import Foundation
import RxSwift

protocol ExchangesFlowDelegate: AnyObject {
    func didTapExchange(on viewModel: ExchangesViewModel)
    func didTapAccounts(on viewModel: ExchangesViewModel)
}

protocol ExchangesViewModel {
    func didTapExchange()
    func didTapAccounts()
    
    var balance: Observable<Double> { get }
    var currency: Observable<String> { get }
    var currencyDescription: Observable<String> { get }
    var transactions: Observable<[Transaction]> { get }
}

final class ExchangesViewModelImpl: ExchangesViewModel {
    
    var balance: Observable<Double> {
        accountService.currentAccount.map { $0.balance }
    }
    
    var currency: Observable<String> {
        accountService.currentAccount.map { $0.currency.rawValue }
    }
    
    var currencyDescription: Observable<String> {
        accountService.currentAccount.map { $0.currency.currencyDescription }
    }
    
    var transactions: Observable<[Transaction]> {
        accountService.currentAccount.map { $0.transactions.reversed() }
    }
    
    
    // MARK: - Flow Delegate
    
    weak var flowDelegate: ExchangesFlowDelegate?
    
    private let accountService: AccountService
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    init(accountService: AccountService) {
        self.accountService = accountService
    }
    
    // MARK: - Public Methods
    
    func didTapExchange() {
        flowDelegate?.didTapExchange(on: self)
    }
    
    func didTapAccounts() {
        flowDelegate?.didTapAccounts(on: self)
    }
}
