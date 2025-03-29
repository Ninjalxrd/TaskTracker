//
//  SettingsView.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import UIKit

class SettingsView: UIView {
    
    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - TableView
    
    lazy var settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(ThemeTableViewCell.self, forCellReuseIdentifier: ThemeTableViewCell.identifier)
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        tableView.allowsSelection = false
        return tableView
    }()
    
    // MARK: - Setup UI
    
    private func setupUI() {
        addSubview(settingsTableView)
        
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - TableViewDelegate


extension SettingsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Sizes.settingsTableViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView()
            headerView.backgroundColor = .clear
            
            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = "Тема оформления"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            titleLabel.textColor = .label
            
            headerView.addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.settingsViewConstant),
                titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Constants.settingsViewConstant),
                titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: Constants.settingsViewSmallConstant),
                titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -Constants.settingsViewSmallConstant)
            ])
            
            return headerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return Sizes.settingsHeightForHeader
        }
        return 0
    }
}
