//
//  KeyboardPresenting.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import UIKit

public protocol KeyboardPresenting {
    var scrollViewForKeyboard: UIScrollView? { get }
    var scrollViewBottomInset: CGFloat { get }

    func keyboardWillShow(frame: CGRect, duration: TimeInterval, animationCurve: UIView.AnimationCurve)
    func keyboardWillHide(frame: CGRect, duration: TimeInterval, animationCurve: UIView.AnimationCurve)
}

extension KeyboardPresenting where Self: UIViewController {

    var scrollViewBottomInset: CGFloat { return 0 }

    func keyboardWillShow(frame: CGRect, duration: TimeInterval, animationCurve: UIView.AnimationCurve) {
        var inset = frame.height

        if let contentInsetAdjustmentBehavior = scrollViewForKeyboard?.contentInsetAdjustmentBehavior {
            switch contentInsetAdjustmentBehavior {
            case .automatic, .always, .scrollableAxes:
                inset -= view.safeAreaInsets.bottom
            case .never:
                break
            @unknown default:
                assertionFailure("New cases have been added")
            }
        }

        updateScrollViewBottomInsetAnimated(inset, duration: duration, animationCurve: animationCurve)
    }

    func keyboardWillHide(frame: CGRect, duration: TimeInterval, animationCurve: UIView.AnimationCurve) {
        let inset = scrollViewBottomInset
        updateScrollViewBottomInsetAnimated(inset, duration: duration, animationCurve: animationCurve)
    }

    private func updateScrollViewBottomInsetAnimated(_ inset: CGFloat, duration: TimeInterval, animationCurve: UIView.AnimationCurve) {
        UIViewPropertyAnimator(duration: duration, curve: animationCurve) { [weak self] in
            self?.updateScrollViewBottomInset(inset)
        }.startAnimation()
    }

    private func updateScrollViewBottomInset(_ inset: CGFloat) {
        scrollViewForKeyboard?.contentInset.bottom = inset
        scrollViewForKeyboard?.verticalScrollIndicatorInsets.bottom = inset
    }
}
