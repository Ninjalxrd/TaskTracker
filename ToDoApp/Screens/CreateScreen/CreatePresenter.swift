//
//  CreatePresenter.swift
//  ToDoApp
//
//  Created by Павел on 27.03.2025.
//

import Foundation
import UIKit

    // MARK: - Protocol
protocol CreatePresenterInput {
    func saveNewTask(with task: TaskEntity)
    func showAlert(title: String, message: String)
}

    // MARK: - CreatePresenter (Presenter)
final class CreatePresenter: CreatePresenterInput {
    
    // MARK: - Dependencies
    
    var interactor: CreateTaskInteractorInput!
    var router: CreateEditTaskRouterProtocol!
        
    // MARK: - Methods
    func saveNewTask(with task: TaskEntity) {
        interactor.saveTaskData(with: task)
    }
    
    func showAlert(title: String, message: String) {
        router.showAlert(title: title, message: message)
    }
}


