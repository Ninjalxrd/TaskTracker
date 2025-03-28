//
//  SettingsPresenter.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//
import UIKit

protocol SettingsPresenterInput {
    func setupSystemTheme(view: UIView)
    func setupLightTheme(view: UIView)
    func setupDarkTheme(view: UIView)
}

protocol SettingsPresenterOutput {
    func setupCallbacks(for cell: ThemeTableViewCell)
}


final class SettingsPresenter: SettingsPresenterInput, SettingsInteractorOutput {
    
    var interactor: SettingsInteractorInput!
    
    func setupSystemTheme(view: UIView) {
        interactor.setupSystemTheme(view: view)
    }
    
    func setupLightTheme(view: UIView) {
        interactor.setupLightTheme(view: view)
    }
    
    func setupDarkTheme(view: UIView) {
        interactor.setupDarkTheme(view: view)
    }
    
    
}
