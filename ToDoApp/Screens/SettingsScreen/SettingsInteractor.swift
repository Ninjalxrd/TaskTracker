//
//  SettingsInteractor.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import UIKit

    //MARK: - Protocols

protocol SettingsInteractorInput {

    func setupViewTheme(view: UIView)
}

final class SettingsInteractor: SettingsInteractorInput {
    
    func setupViewTheme(view: UIView) {
        view.window?.overrideUserInterfaceStyle = ThemeUserDefaults.shared.theme.getUserInterfaceStyle()
    }
    

}
