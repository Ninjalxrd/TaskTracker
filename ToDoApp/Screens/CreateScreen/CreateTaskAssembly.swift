//
//  CreateTaskAssembly.swift
//  ToDoApp
//
//  Created by Павел on 25.03.2025.
//

import UIKit

final class CreateTaskAssembly {
    
    static func buildScreen() -> UIViewController {
        let view = CreateEditTaskViewController()
        let presenter = CreatePresenter()
        let router = CreateEditTaskRouter()
        let coreDataManager = CoreDataManager.shared
        
        let interactor = CreateTaskInteractor()

        view.createPresenter = presenter
        presenter.interactor = interactor
        presenter.viewController = view
        presenter.router = router
        interactor.coreDataManager = coreDataManager

        router.view = view
        
        return view
    }
    
    private init() { }
}
