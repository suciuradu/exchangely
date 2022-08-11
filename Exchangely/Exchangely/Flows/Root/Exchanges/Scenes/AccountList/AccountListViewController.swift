//
//  AccountListViewController.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import UIKit
import SnapKit

final class AccountListViewController: BaseViewController {
    
    // MARK: - Private Methods
    
    private let viewModel: AccountListViewModel
    private let tableView = UITableView(frame: .zero, style: .grouped)

    // MARK: - Init
    
    init(viewModel: AccountListViewModel) {
        self.viewModel = viewModel

        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        view.backgroundColor = .systemGray6

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: AccountListTableViewCell.self)
        tableView.contentInset.top = 4
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
    }
    
    override func setupBindings() {
        super.setupBindings()
        
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top).inset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension AccountListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AccountListTableViewCell.self)
        cell.viewModel = AccountListCellViewModel(account: viewModel.accounts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionTitleView = SectionTitleView()
        sectionTitleView.backgroundColor = view.backgroundColor
        sectionTitleView.title = "Accounts"
        
        return sectionTitleView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectAccount(at: indexPath.row)
    }
}
