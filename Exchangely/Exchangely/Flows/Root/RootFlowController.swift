//
//  RootFlowController.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import UIKit

class RootFlowController {

    // MARK: - Private Properties

    weak var window: UIWindow?

    // MARK: - Private Properties

    private let appCore: AppCore

    // MARK: - FlowControllers

    private var splashScreenFlowController: NavigationFlowController?
    private var exchangesFlowController: NavigationFlowController?

    // MARK: - Init

    init(window: UIWindow?, appCore: AppCore) {
        self.window = window
        self.appCore = appCore
    }
    
    // MARK: - Public Methods

    func start() {
        showSplashScreenFlowController()
    }

    // MARK: - Private Methods

    private func showSplashScreenFlowController() {
        let splashScreenFlowController = SplashScreenFlowController()
        splashScreenFlowController.flowDelegate = self
        self.splashScreenFlowController = splashScreenFlowController

        show(flow: splashScreenFlowController)
    }
    
    private func showExchangesFlowController() {
        let exchangesFlowController = ExchangesFlowController(appCore: appCore)
        self.exchangesFlowController = exchangesFlowController
        
        show(flow: exchangesFlowController) { [weak self] in
            self?.splashScreenFlowController = nil
        }
    }
}

// MARK: - SplashScreenFlowControllerDelegate

extension RootFlowController: SplashScreenFlowControllerDelegate {
    
    func didFinish(on flow: SplashScreenFlowController) {
        showExchangesFlowController()
    }
}
