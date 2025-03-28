//
//  TasksAssembly.swift
//  ToDoApp
//
//  Created by Павел on 20.03.2025.
//

import Foundation
import UIKit

final class TasksAssembly {
    
    static func buildScreen() -> UIViewController {
        
        let view = TasksViewController()
        let presenter = TasksPresenter()
        let interactor = TasksInteractor()
        let router = TasksRouter()
        let network = NetworkService()
        let coreDataManager = CoreDataManager.shared
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.viewController = view
        presenter.router = router
        interactor.presenter = presenter
        interactor.networkService = network
        interactor.coreDataManager = coreDataManager
        router.view = view

        return view
    }
    
    private init() {
    }
    
    
}
