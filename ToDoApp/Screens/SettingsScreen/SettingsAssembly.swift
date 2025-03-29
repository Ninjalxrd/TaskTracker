//
//  SettingsAssembly.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import UIKit

final class SettingsAssembly {
    
    static func buildScreen() -> UIViewController {
        let view = SettingsViewController()
        let presenter = SettingsPresenter()
        let interactor = SettingsInteractor()
        
        view.presenter = presenter
        presenter.interactor = interactor
        
        return view
    }
    
    private init() {}
}
