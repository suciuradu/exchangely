//
//  AppCore.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import Foundation

final class AppCore {

    // MARK: - Public Properties

    var exchangeService: ExchangeService
    var accountService: AccountService

    // MARK: - Init

    init() {
        let networkClient = NetworkClient()
        self.exchangeService = ExchangeService(networkClient: networkClient)
        self.accountService = AccountService()
    }
}

