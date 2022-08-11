//
//  SectionTitleView.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import UIKit
import SnapKit

final class SectionTitleView: UIView {
    
    // MARK: - Public Method
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    // MARK: - Private Properties

    private let titleLabel = UILabel()
    
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
        backgroundColor = .clear
        
        titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .black
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
}
