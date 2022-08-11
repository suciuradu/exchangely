//
//  BaseViewController.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Base Class Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        signUpForKeyboardNotifications()
        setupView()
        setupConstraints()
        setupBindings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    // MARK: - Methods which each view controller should override

    func setupView() { }
    func setupConstraints() { }
    func setupBindings() { }
    
    // MARK: - Notifications

    private func signUpForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIApplication.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardPresenter = self as? KeyboardPresenting else { return }
        guard let (frame, duration, animationCurve) = keyboardParameters(userInfo: notification.userInfo) else { return }
        keyboardPresenter.keyboardWillShow(frame: frame, duration: duration, animationCurve: animationCurve)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let keyboardPresenter = self as? KeyboardPresenting else { return }
        guard let (frame, duration, animationCurve) = keyboardParameters(userInfo: notification.userInfo) else { return }
        keyboardPresenter.keyboardWillHide(frame: frame, duration: duration, animationCurve: animationCurve)
    }

    private func keyboardParameters(userInfo: [AnyHashable: Any]?) -> (CGRect, TimeInterval, UIView.AnimationCurve)? {
        guard let frame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return nil }
        guard let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return nil }
        guard let animationCurveRawValue = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int) else { return nil }
        guard let animationCurve = UIView.AnimationCurve(rawValue: animationCurveRawValue) else { return nil }

        return (frame, duration, animationCurve)
    }
}
