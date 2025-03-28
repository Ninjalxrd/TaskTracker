//
//  SettingsViewController.swift
//  ToDoApp
//
//  Created by Павел on 24.03.2025.
//

import UIKit

final class SettingsViewController: UIViewController, SettingsPresenterOutput {

    private let settingView: SettingsView = .init()
    var presenter: SettingsPresenterInput!

    override func loadView() {
        super.loadView()
        view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingView.settingsTableView.dataSource = self
    }
    
    func setupCallbacks(for cell: ThemeTableViewCell) {
        cell.setSystemTheme = { [weak self] in
            guard let self else { return }
            self.presenter.setupSystemTheme(view: self.view)
        }
        cell.setLightTheme = { [weak self] in
            guard let self else { return }
            self.presenter.setupLightTheme(view: self.view)
        }
        cell.setDarkTheme = { [weak self] in
            guard let self else { return }
            self.presenter.setupDarkTheme(view: self.view)
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ThemeTableViewCell.identifier, for: indexPath) as! ThemeTableViewCell
        setupCallbacks(for: cell)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        <#code#>
//    }
}
