//
//  SceneDelegate.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Public Properties

    var window: UIWindow?
    var flow: RootFlowController?

    // MARK: - Private Properties

    private lazy var appCore = AppCore()

    // MARK: - Public Methods

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        self.window = window
        window.makeKeyAndVisible()

        flow = RootFlowController(window: window, appCore: appCore)
        flow?.start()
    }
}

