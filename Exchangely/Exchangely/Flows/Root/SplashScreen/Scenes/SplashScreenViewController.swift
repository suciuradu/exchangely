//
//  SplashScreenViewController.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import UIKit
import SnapKit

final class SplashScreenViewController: BaseViewController {
    
    // MARK: - Private Methods
    
    private let viewModel: SplashScreenViewModel
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "E X C H A N G E L Y"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.alpha = 0
        
        return label
    }()

    // MARK: - Init
    
    init(viewModel: SplashScreenViewModel) {
        self.viewModel = viewModel

        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.6) { [weak self] in
            self?.titleLabel.alpha = 1
        } completion: { [weak self] _ in
            self?.viewModel.viewDidLoad()
        }

    }
}
