//
//  AccountListViewModel.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import Foundation


protocol AccountListFlowDelegate: AnyObject {
    func didSelectAccount(on viewModel: AccountListViewModel, selectedAccount: Account)
}

protocol AccountListViewModel {
    var accounts: [Account] { get }
    var context: AccountListViewModelImpl.Context { get }
    
    func didSelectAccount(at index: Int)
}

final class AccountListViewModelImpl: AccountListViewModel {
    
    enum Context {
        case exchanges
        case convertCurrency
    }
    
    // MARK: - Public properties
    
    weak var flowDelegate:  AccountListFlowDelegate?
    
    var accounts: [Account] { accountService.getExcludedAccountList() }
    let context: Context
    
    // MARK: - Private properties
    
    private let accountService: AccountService
    
    // MARK: - Init
    
    init(accountService: AccountService, context: Context) {
        self.accountService = accountService
        self.context = context
    }
    
    // MARK: - Public Methods
    
    func didSelectAccount(at index: Int) {
        flowDelegate?.didSelectAccount(on: self, selectedAccount: accounts[index])
    }
    
}
