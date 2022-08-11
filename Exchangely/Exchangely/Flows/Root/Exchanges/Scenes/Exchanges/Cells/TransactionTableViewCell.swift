//
//  TransactionTableViewCell.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import UIKit
import SnapKit

final class TransactionTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    var viewModel: TransactionCellViewModel? {
        didSet {
            currencyLabel.text = viewModel?.currencyText
            amountLabel.text = viewModel?.amountText
        }
    }
    
    // MARK: - Private Properties
    
    private let containerView = UIView()
    private let containerStackView = UIStackView()
    private let thumbnailImageView = UIImageView()
    private let currencyLabel = UILabel()
    private let amountLabel = UILabel()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.height / 2
        thumbnailImageView.layer.masksToBounds = true
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = backgroundColor
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)
        
        containerStackView.backgroundColor = .clear
        containerStackView.axis = .horizontal
        containerStackView.spacing = 16
        containerStackView.distribution = .fill
        containerStackView.alignment = .center
        containerView.addSubview(containerStackView)
        
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.image = UIImage(named: .thumbnailImage)
        containerStackView.addArrangedSubview(thumbnailImageView)
        
        currencyLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        currencyLabel.textColor = .black
        amountLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        amountLabel.textColor = .black
        
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.addArrangedSubview(currencyLabel)
        textStackView.addArrangedSubview(amountLabel)
        containerStackView.addArrangedSubview(textStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(4)
        }
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalTo(containerView).inset(8)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.size.equalTo(50)
        }
    }
}

private extension String {
    static let thumbnailImage = "icn_exchange_color"
}
