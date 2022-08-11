//
//  ActionButton.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import UIKit.UIButton
import SnapKit

private extension UIColor {
    static let backgroundColor: UIColor = .blue.withAlphaComponent(0.6)
    static let disabledBackgroundColor: UIColor = .blue.withAlphaComponent(0.1)
    static let titleColor: UIColor = .white
}

class ActionButton: UIButton {
    
    private enum SelectorStateType {
        case touchDragInside
        case touchDragOutside
        case initial
    }
    
    enum Style {
        case primary
        case secondary
        case primaryWithDisabledAlpha
    }

    // MARK: - Public properties
    
    var animationDuration: TimeInterval = 0.33
    var shouldAnimate = true

    override public var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .backgroundColor : .disabledBackgroundColor

            setTitleColor(isEnabled ? .titleColor : .disabledBackgroundColor, for: .normal)
        }
    }

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 48)
    }

    var isLoading: Bool = false {
        didSet {
            guard isLoading != oldValue else { return }

            isUserInteractionEnabled = !isLoading
            spinner.isHidden = !isLoading
            isLoading ? spinner.startAnimating() : spinner.stopAnimating()

            setTitleColor(isLoading ? .clear : .titleColor, for: .normal)
        }
    }

    // MARK: - Private properties

    private let spinner = UIActivityIndicatorView()
    private var selectorState: SelectorStateType = .initial
    private let feedbackGenerator = UISelectionFeedbackGenerator()

    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 10
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        initLayout()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
        initLayout()
    }

    private func initView() {
        setup()
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)

        spinner.isHidden = true
        addSubview(spinner)

        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        addTarget(self, action: #selector(touchDragOutside), for: .touchDragOutside)
        addTarget(self, action: #selector(touchDragInside), for: .touchDown)
        addTarget(self, action: #selector(touchDragInside), for: .touchDragInside)
    }
    
    private func setup() {
        backgroundColor = .backgroundColor

        setTitleColor(.titleColor, for: .normal)
        spinner.color = .titleColor
    }

    private func initLayout() {
        spinner.snp.makeConstraints { $0.center.equalTo(self) }
    }

    @objc private func touchUpInside() {
        feedbackGenerator.selectionChanged()
        selectorState = .touchDragOutside
        animate(dragInside: false)
    }

    @objc private func touchDragInside() {
        if selectorState != .touchDragInside {
            selectorState = .touchDragInside
            animate(dragInside: true)
        }
    }

    @objc private func touchDragOutside() {
        if selectorState != .touchDragOutside {
            selectorState = .touchDragOutside
            animate(dragInside: false)
        }
    }

    private func animate(dragInside: Bool) {
        guard shouldAnimate else { return }
        
        UIView.animate(withDuration: animationDuration, delay: .zero, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.transform = dragInside ? CGAffineTransform.init(scaleX: 0.98, y: 0.98) :  CGAffineTransform.identity
            self.alpha = dragInside ? 0.92 : 1.0
        }, completion: nil)
    }
}
