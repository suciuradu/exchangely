//
//  ExchangesViewController.swift
//  Exchangely
//
//  Created by Suciu Radu on 09.08.2022.
//

import UIKit
import RxSwift
import SnapKit

final class ExchangesViewController: BaseViewController {
    
    // MARK: - Public Properties
    
    var viewModel: ExchangesViewModel!
    
    // MARK: - Private Properties
    
    private let disposeBag = DisposeBag()
    private var transactionsList: [Transaction] = []
    
    private lazy var tableViewHeader: BalanceTableHeaderView = {
        let header = BalanceTableHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.delegate = self
        
        return header
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .placeholderText
        label.textAlignment = .center
        label.text = .emptyTransactionList
        
        return label
    }()
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationAppearance()
    }
    
    // MARK: - Public Methods
    
    override func setupView() {
        super.setupView()
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(emptyStateLabel)
        emptyStateLabel.isHidden = true
        
        setupTableView()
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        Observable.combineLatest(viewModel.balance, viewModel.currency, viewModel.currencyDescription)
            .bind { [weak self] balance, currency, currencyDescription in
                DispatchQueue.main.async {
                    self?.tableViewHeader.setup(amount: balance, currency: currency, currencyDescription: currencyDescription)
                }
            }.disposed(by: disposeBag)
        
        viewModel.transactions
            .bind { [weak self] transactions in
                self?.transactionsList = transactions
                self?.tableView.reloadData()
            }.disposed(by: disposeBag)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        emptyStateLabel.snp.makeConstraints { $0.center.equalTo(tableView.snp.center) }
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: TransactionTableViewCell.self)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        
        tableView.setAndLayoutTableHeaderView(tableViewHeader)
        tableViewHeader.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
    }
    
    private func setupNavigationAppearance() {
        navigationItem.title = .navigationTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: .emptyString, style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
    }
}

// MARK: -  UITableViewDelegate, UITableViewDataSource

extension ExchangesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyStateLabel.isHidden = transactionsList.count > 0
        return transactionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TransactionTableViewCell.self)
        cell.viewModel = TransactionCellViewModel(transaction: transactionsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionTitleView = SectionTitleView()
        sectionTitleView.title = .sectionTitle
        
        return sectionTitleView
    }
}

// MARK: - BalanceTableHeaderViewDelegate

extension ExchangesViewController: BalanceTableHeaderViewDelegate {
    func didTapExchange() {
        viewModel.didTapExchange()
    }
    
    func didTapAccounts() {
        viewModel.didTapAccounts()
    }
}

private extension String {
    static let navigationTitle = "E X C H A N G E L Y"
    static let sectionTitle = "Transactions"
    static let emptyString = ""
    static let emptyTransactionList = "There are no transactions yet."
}
