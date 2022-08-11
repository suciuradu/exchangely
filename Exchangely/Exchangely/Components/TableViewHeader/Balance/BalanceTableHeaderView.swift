//
//  BalanceTableHeaderView.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import UIKit
import SnapKit

protocol BalanceTableHeaderViewDelegate: AnyObject {
    func didTapExchange()
    func didTapAccounts()
}

final class BalanceTableHeaderView: UIView, NibRepresentable {
    
    // MARK: - Public Properties
    
    weak var delegate: BalanceTableHeaderViewDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var bigAmountLabel: UILabel!
    @IBOutlet private weak var decimalAmountLabel: UILabel!
    @IBOutlet private weak var commaLabel: UILabel!
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var currencyDescriptionLabel: UILabel!
    @IBOutlet private weak var mainStackView: UIStackView!
    @IBOutlet private weak var balanceStackView: UIStackView!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var exchangeButton: ActionButton!
    @IBOutlet private weak var accountsButton: ActionButton!
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 6
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Public Methods
    
    func setup(amount: Double, currency: String, currencyDescription: String) {
        let whole = Int(amount.whole)
        let fraction = Int(amount.fraction)
        
        bigAmountLabel.text = "\(whole)"
        decimalAmountLabel.text = "\(fraction)"
        currencyLabel.text = currency
        currencyDescriptionLabel.text = currencyDescription
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        loadNib()
        
        headerTitleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        headerTitleLabel.text = "Balance"
        
        bigAmountLabel.font = .systemFont(ofSize: 20, weight: .medium)
        commaLabel.font = .systemFont(ofSize: 20, weight: .medium)
        commaLabel.text = ","
        decimalAmountLabel.font = .systemFont(ofSize: 16, weight: .medium)
        currencyLabel.font = .systemFont(ofSize: 20, weight: .medium)
        currencyDescriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
    
        exchangeButton.setTitle("Exchange", for: .normal)
        accountsButton.setTitle("Accounts", for: .normal)
        buttonsStackView.snp.makeConstraints { $0.leading.trailing.equalToSuperview() }
        
        mainStackView.setCustomSpacing(24, after: currencyDescriptionLabel)
        balanceStackView.setCustomSpacing(8, after: decimalAmountLabel)
    }
    
    // MARK: - Actions

    @IBAction func didTapExchange(_ sender: Any) {
        delegate?.didTapExchange()
    }
    
    @IBAction func didTapAccounts(_ sender: Any) {
        delegate?.didTapAccounts()
    }
}

// Helper

private extension Double {
    var whole: Self { modf(self).0 }
    var fraction: Self { modf(self).1 * 100 }
}
