//
//  SettingsPresenter.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//
import UIKit

    // MARK: - Protocol

protocol SettingsPresenterInput {
    func setupViewTheme(_ view: UIView)
}

final class SettingsPresenter: SettingsPresenterInput {
    
    // MARK: - Dependencies
    
    var interactor: SettingsInteractorInput!
    
    func setupViewTheme(_ view: UIView) {
        interactor.setupViewTheme(view: view)
    }
    
}
