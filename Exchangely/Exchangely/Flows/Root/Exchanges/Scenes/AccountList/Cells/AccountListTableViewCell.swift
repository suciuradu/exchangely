//
//  AccountListTableViewCell.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import UIKit
import SnapKit

final class AccountListTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    var viewModel: AccountListCellViewModel? {
        didSet {
            currencyLabel.text = viewModel?.currency
            currencyDescriptionLabel.text = viewModel?.currencyDescription
            balanceLabel.text = viewModel?.balanceComputed
        }
    }
    
    // MARK: - Private Properties
    
    private let containerView = UIView()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var currencyStackView: UIStackView = {
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
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    private lazy var currencyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 19, weight: .medium)
        
        return label
    }()
    
    private lazy var countryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icn_country_default")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 10
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = backgroundColor
        
        addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(4)
        }
        
        containerView.addSubview(countryImage)
        countryImage.snp.makeConstraints {
            $0.height.width.equalTo(45)
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        
        containerView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.leading.equalTo(countryImage.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(10)
            
        }
        
        mainStackView.addArrangedSubview(currencyStackView)
        mainStackView.addArrangedSubview(balanceLabel)
        
        currencyStackView.addArrangedSubview(currencyLabel)
        currencyStackView.addArrangedSubview(currencyDescriptionLabel)
        
    }
}
