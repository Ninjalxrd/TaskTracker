//
//  CreateTaskInteractor.swift
//  ToDoApp
//
//  Created by Павел on 25.03.2025.
//

protocol CreateTaskInteractorInput {
    func saveTaskData(with task: TaskEntity)
}

protocol CreateTaskInteractorOutput {
    func saveTaskData(with task: TaskEntity)
}

final class CreateTaskInteractor: CreateTaskInteractorInput {
    
    var coreDataManager: CoreDataManagerInput!
    
    func saveTaskData(with task: TaskEntity) {
        coreDataManager.saveNewTask(with: task)
    }
}
