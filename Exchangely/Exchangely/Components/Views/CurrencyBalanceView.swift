//
//  CurrencyBalanceView.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import UIKit
import SnapKit

final class CurrencyBalanceView: UIView {
    
    enum Context {
        case fromCurrency(currency: String, balance: Double)
        case toCurrency(currency: String, balance: Double)
        
        var placeholder: String {
            switch self {
            case .fromCurrency:
                return "-0"
            case .toCurrency:
                return "+0"
            }
        }
        
        var isTextFieldEnabled: Bool {
            switch self {
            case .fromCurrency:
                return true
            case .toCurrency:
                return false
            }
        }
    }
    
    // MARK: - Public Properties
    
    var textField: UITextField { amountTextField }
    
    // MARK: - Private Properties
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var balanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        
        return label
    }()
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 22, weight: .medium)
        textField.textAlignment = .right
        textField.placeholder = "-0"
        textField.borderStyle = .none
        textField.minimumFontSize = 12
        textField.keyboardType = .decimalPad
        
        return textField
    }()
    
    // MARK: - LifeCycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(12) }
        
        mainStackView.addArrangedSubview(balanceStackView)
        mainStackView.addArrangedSubview(amountTextField)
        
        balanceStackView.addArrangedSubview(currencyLabel)
        balanceStackView.addArrangedSubview(balanceLabel)
    }
    
    // MARK: - Public Methods
    
    func setupData(for context: Context) {
        switch context {
        case .fromCurrency(let currency, let balance),
             .toCurrency(let currency, let balance):
            currencyLabel.text = currency
            balanceLabel.text = "Balance: \(balance)"
            amountTextField.placeholder = context.placeholder
            amountTextField.isUserInteractionEnabled = context.isTextFieldEnabled
        }
    }
}

