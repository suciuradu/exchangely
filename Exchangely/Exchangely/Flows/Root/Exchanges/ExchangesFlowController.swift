//
//  ExchangesFlowController.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import UIKit

protocol ExchangesFlowControllerDelegate: AnyObject {
    func didFinish(on flow: SplashScreenFlowController)
}

final class ExchangesFlowController: NavigationFlowController {

    // MARK: - Public properties

    weak var flowDelegate: ExchangesFlowControllerDelegate?
    
    // MARK: - Private Properties
    
    private let appCore: AppCore
    
    private var convertCurrencyViewModel: ConvertCurrencyViewModel? { (navigationController?.viewControllers.first { $0 is ConvertCurrencyViewController } as? ConvertCurrencyViewController)?.viewModel }

    // MARK: - Init
    
    init(appCore: AppCore, from parent: FlowController? = nil, for presentation: FlowControllerPresentation = .custom) {
        self.appCore = appCore
        
        super.init(from: parent, for: presentation)
    }
    
    required init(from parent: FlowController? = nil, for presentation: FlowControllerPresentation = .present) {
        fatalError("init(from:for:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func firstScreen() -> UIViewController {
        let viewController = ExchangesViewController.instantiate()
        viewController.viewModel = {
            let viewModel = ExchangesViewModelImpl(accountService: appCore.accountService)
            viewModel.flowDelegate = self
            return viewModel
        }()
        return viewController
    }
    
    // MARK: - Private Methods
    
    private func showConvertCurrencyScreen() {
        let viewController = ConvertCurrencyViewController.instantiate()
        viewController.viewModel = {
            let viewModel = ConvertCurrencyViewModelImpl(exchangeService: appCore.exchangeService, accountSerivce: appCore.accountService)
            viewModel.flowDelegate = self
            return viewModel
        }()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showAccountScreen(context: AccountListViewModelImpl.Context) {
        let viewController = AccountListViewController(viewModel: {
            let viewModel = AccountListViewModelImpl(accountService: appCore.accountService, context: context)
            viewModel.flowDelegate = self
            return viewModel
        }())
        
        navigationController?.present(viewController, animated: true)
    }
}

// MARK: - SplashScreenFlowDelegate

extension ExchangesFlowController: ExchangesFlowDelegate {
    func didTapExchange(on viewModel: ExchangesViewModel) {
        showConvertCurrencyScreen()
    }
    
    func didTapAccounts(on viewModel: ExchangesViewModel) {
        showAccountScreen(context: .exchanges)
    }
}

// MARK: - ConvertCurrencyFlowDelegate

extension ExchangesFlowController: ConvertCurrencyFlowDelegate {
    func didTapExchange(on viewModel: ConvertCurrencyViewModel) {
        navigationController?.popViewController(animated: true)
    }
    
    func changeExchangeAccount(on viewModel: ConvertCurrencyViewModel) {
        showAccountScreen(context: .convertCurrency)
    }
}

// MARK: - AccountListFlowDelegate

extension ExchangesFlowController: AccountListFlowDelegate {
    func didSelectAccount(on viewModel: AccountListViewModel, selectedAccount: Account) {
        switch viewModel.context {
        case .exchanges:
            appCore.accountService.setNewCurrent(account: selectedAccount)
            navigationController?.dismiss(animated: true)
        case .convertCurrency:
            convertCurrencyViewModel?.updateExchangeAccount(to: selectedAccount)
            navigationController?.dismiss(animated: true)
        }
    }
}
