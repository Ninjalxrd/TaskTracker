//
//  EditTaskAssembly.swift
//  ToDoApp
//
//  Created by Павел on 24.03.2025.
//

import Foundation
import UIKit

    // MARK: - Asssembly Edit Screen
final class EditTaskAssembly {
    
    static func buildScreen(task: TaskEntity?) -> UIViewController {
        
        let view = EditViewController(currentTask: task)
        let presenter = EditPresenter()
        let interactor = EditTaskInteractor()
        let coreDataManager = CoreDataManager.shared
        
        view.editPresenter = presenter
        presenter.interactor = interactor
        presenter.viewController = view
        interactor.presenter = presenter
        interactor.coreDataManager = coreDataManager

        return view
    }
    
    private init() { }
    
}
