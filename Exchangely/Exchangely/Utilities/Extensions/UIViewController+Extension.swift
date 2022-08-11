//
//  UIViewController+Extension.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import UIKit

extension UIViewController {

    class var storyboardId: String {
        return "\(self)"
    }

    static func instantiate() -> Self {
        return viewController(viewControllerClass: self)
    }

    private static func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboard = UIStoryboard(name: storyboardId, bundle: Bundle(for: self))
        guard let scene = storyboard.instantiateInitialViewController() as? T else { fatalError() }

        return scene
    }
}
