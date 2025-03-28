//
//  CreatePresenter.swift
//  ToDoApp
//
//  Created by Павел on 27.03.2025.
//
import Foundation
import UIKit

protocol CreatePresenterInput {
    func saveNewTask(with task: TaskEntity)
    func showAlert(title: String, message: String)
}

protocol CreatePresenterOutput {
    func saveTaskData()

}

final class CreatePresenter: CreatePresenterInput {
    
    var viewController: CreatePresenterOutput!
    var interactor: CreateTaskInteractorInput!
    var router: CreateEditTaskRouterProtocol!
        
    func saveNewTask(with task: TaskEntity) {
        interactor.saveTaskData(with: task)
    }
    
    func showAlert(title: String, message: String) {
        router.showAlert(title: title, message: message)
    }
}


