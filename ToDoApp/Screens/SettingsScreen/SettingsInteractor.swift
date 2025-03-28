//
//  SettingsInteractor.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import UIKit

protocol SettingsInteractorInput {
    func setupSystemTheme(view: UIView)
    func setupLightTheme(view: UIView)
    func setupDarkTheme(view: UIView)
    func setupViewTheme(view: UIView)
}

protocol SettingsInteractorOutput {
    func setupSystemTheme(view: UIView)
    func setupLightTheme(view: UIView)
    func setupDarkTheme(view: UIView)
}

final class SettingsInteractor: SettingsInteractorInput {
    
    func setupSystemTheme(view: UIView) {
        ThemeUserDefaults.shared.theme = Theme(rawValue: 0) ?? .dark
        setupViewTheme(view: view)
    }
    
    func setupLightTheme(view: UIView) {
        ThemeUserDefaults.shared.theme = Theme(rawValue: 1) ?? .dark
        setupViewTheme(view: view)
    }
    
    func setupDarkTheme(view: UIView) {
        ThemeUserDefaults.shared.theme = Theme(rawValue: 2) ?? .dark
        setupViewTheme(view: view)
    }
    
    func setupViewTheme(view: UIView) {
        view.window?.overrideUserInterfaceStyle = ThemeUserDefaults.shared.theme.getUserInterfaceStyle()
    }
    

}
