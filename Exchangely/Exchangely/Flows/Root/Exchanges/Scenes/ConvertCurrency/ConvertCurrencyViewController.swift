//
//  ConvertCurrencyViewController.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ConvertCurrencyViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var mainStackView: UIStackView!
    @IBOutlet private weak var exchangeButton: ActionButton!
    @IBOutlet private weak var fromCurrencyView: CurrencyBalanceView!
    @IBOutlet private weak var toCurrencyView: CurrencyBalanceView!
    @IBOutlet private weak var exchangeButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var comissionLabel: UILabel!
    
    // MARK: - Public properties
    
    var viewModel: ConvertCurrencyViewModel!
    
    // MARK: - Private properties
    
    private let disposeBag = DisposeBag()

    private lazy var conversionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icn_circle_arrow_dowm")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fromCurrencyView.textField.becomeFirstResponder()
    }
    
    // MARK: - UI
    
    override func setupView() {
        super.setupView()
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = viewModel.navigationTitle
        
        view.addSubview(conversionImageView)
        
        exchangeButton.setTitle(viewModel.exchangeButtonTitle, for: .normal)
        exchangeButton.isEnabled = false
        fromCurrencyView.setupData(for: .fromCurrency(currency: viewModel.currency, balance: viewModel.currentAccount.balance.roundTwoDecimals()))
        toCurrencyView.setupData(for: .toCurrency(currency: viewModel.exchagedCurrency, balance: viewModel.exchangeAccount.balance.roundTwoDecimals()))
        
        toCurrencyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeAccount)))
        
        comissionLabel.font = .systemFont(ofSize: 10, weight: .medium)
        comissionLabel.textAlignment = .center
        comissionLabel.textColor = .blue.withAlphaComponent(0.6)
        comissionLabel.text = viewModel.comissionDescription
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        conversionImageView.snp.makeConstraints {
            $0.height.width.equalTo(40)
            $0.center.equalTo(mainStackView.snp.center)
        }
    }
    
    // MARK: - Bindings

    override func setupBindings() {
        super.setupBindings()
        
        fromCurrencyView.textField.rx
            .text
            .orEmpty
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .bind { [weak self] amount in
                guard
                    let self = self,
                    let amount = Double(amount),
                    amount < self.viewModel.currentAccount.balance
                else {
                    self?.exchangeButton.isEnabled = false
                    return
                }
                
                self.exchangeButton.isEnabled = true
                self.viewModel.makeConversion(for: amount)
            }.disposed(by: disposeBag)
        
        viewModel.amountToBeChanged
            .bind(to: toCurrencyView.textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.updateExchangeAccount
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.toCurrencyView.textField.text = ""
                self.toCurrencyView.setupData(for: .toCurrency(currency: self.viewModel.exchagedCurrency, balance: self.viewModel.exchangeAccount.balance))
                
                self.fromCurrencyView.textField.text = ""
            }.disposed(by: disposeBag)
        
        viewModel.comissionFee
            .bind { [weak self] comission in
                guard let self = self else { return }
                self.comissionLabel.text = self.viewModel.comissionDescription + " - \(comission) \(self.viewModel.currency)"
            }.disposed(by: disposeBag)
        
    }
    
    // MARK: - Private methods
    
    @objc private func changeAccount() {
        viewModel.changeExchangeAccount()
    }
    
    // MARK: - User interaction
    
    
    @IBAction func didTapExchange(_ sender: Any) {
        viewModel.didTapExchange()
    }
}

// MARK: - KeyboardPresenting

extension ConvertCurrencyViewController: KeyboardPresenting {

    var scrollViewForKeyboard: UIScrollView? { nil }
    
    func keyboardWillShow(frame: CGRect, duration: TimeInterval, animationCurve: UIView.AnimationCurve) {
        exchangeButtonBottomConstraint.constant = frame.height - view.safeAreaInsets.bottom + 16
        UIView.animate(withDuration: 0.33) {
            self.view.layoutIfNeeded()
        }
    }
}
