//
//  SettingsViewController.swift
//  ToDoApp
//
//  Created by Павел on 24.03.2025.
//

import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Properties
    private let settingView: SettingsView = .init()
    var presenter: SettingsPresenterInput!

    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingView.settingsTableView.dataSource = self
    }
    
    // MARK: - Setup Callbacks

    func setupCallbacks(for cell: ThemeTableViewCell) {
        cell.setSystemTheme = { [weak self] in
            guard let self else { return }
            ThemeUserDefaults.shared.theme = Theme(rawValue: 0) ?? .dark
            self.presenter.setupViewTheme(self.view)
        }
        cell.setLightTheme = { [weak self] in
            guard let self else { return }
            ThemeUserDefaults.shared.theme = Theme(rawValue: 1) ?? .dark
            self.presenter.setupViewTheme(self.view)
        }
        cell.setDarkTheme = { [weak self] in
            guard let self else { return }
            ThemeUserDefaults.shared.theme = Theme(rawValue: 2) ?? .dark
            self.presenter.setupViewTheme(self.view)
        }
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ThemeTableViewCell.identifier, for: indexPath) as! ThemeTableViewCell
        setupCallbacks(for: cell)
        return cell
    }
}
