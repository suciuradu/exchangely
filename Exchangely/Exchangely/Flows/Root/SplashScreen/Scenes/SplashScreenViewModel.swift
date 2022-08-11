//
//  SplashScreenViewModel.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import Foundation

protocol SplashScreenFlowDelegate: AnyObject {
    func finishSplashScreenPresentation(on viewModel: SplashScreenViewModel)
}

protocol SplashScreenViewModel {
    func viewDidLoad()
}

final class SplashScreenViewModelImpl: SplashScreenViewModel {
    
    // MARK: - FlowDelegate

    weak var flowDelegate: SplashScreenFlowDelegate?
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) { [weak self] in
            guard let self = self else { return }
            
            self.flowDelegate?.finishSplashScreenPresentation(on: self)
        }
    }
}
