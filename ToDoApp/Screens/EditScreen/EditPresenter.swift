//
//  EditPresenter.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import Foundation

protocol EditTaskPresenterInput {
    func obtainTask(for taskId: UUID)
    func updateTaskData(with task: TaskEntity)
}

protocol EditTaskPresenterOutput {
    func setupForEditing(task: TaskEntity)
    func fetchTaskData()
    func saveTaskData()
    func setupCallback()
}

final class EditPresenter: EditTaskPresenterInput {

    var viewController: EditTaskPresenterOutput!
    var interactor: EditTaskInteractorInput!
    
    func obtainTask(for taskId: UUID) {
        interactor.obtainTaskData(for: taskId)
    }

    func updateTaskData(with task: TaskEntity) {
        interactor.updateTaskData(with: task)
    }
    
}

//MARK: - Extensions

extension EditPresenter: EditTaskInteractorOutput {

    func didObtainTask(_ task: TaskEntity) {
        viewController.setupForEditing(task: task)
    }
    
}

