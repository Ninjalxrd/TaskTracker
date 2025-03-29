//
//  EditPresenter.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import Foundation

// MARK: - Protocols
protocol EditTaskPresenterInput: AnyObject {
    func obtainTask(for taskId: UUID)
    func updateTaskData(with task: TaskEntity)
}

protocol EditTaskPresenterOutput: AnyObject {
    func setupForEditing(task: TaskEntity)
}

// MARK: - EditTaskPresenterInput Implementation
final class EditPresenter: EditTaskPresenterInput {
    
    // MARK: - Properties
    weak var viewController: EditTaskPresenterOutput?
    var interactor: EditTaskInteractorInput!
    
    // MARK: - Fetching and Updating Tasks
    func obtainTask(for taskId: UUID) {
        interactor.obtainTaskData(for: taskId)
    }

    func updateTaskData(with task: TaskEntity) {
        interactor.updateTaskData(with: task)
    }
}

// MARK: - EditTaskInteractorOutput Implementation
extension EditPresenter: EditTaskInteractorOutput {

    func didObtainTask(_ task: TaskEntity) {
        viewController?.setupForEditing(task: task)
    }
}


