//
//  CreateTaskInteractor.swift
//  ToDoApp
//
//  Created by Павел on 25.03.2025.
//

// MARK: - Protocol
protocol CreateTaskInteractorInput {
    func saveTaskData(with task: TaskEntity)
}

// MARK: - CreateTaskInteractor (Interactor)
final class CreateTaskInteractor: CreateTaskInteractorInput {
    
    // MARK: - Dependencies
    var coreDataManager: CoreDataManagerInput!
    
    // MARK: - Methods
    
    func saveTaskData(with task: TaskEntity) {
        coreDataManager.saveNewTask(with: task)
    }
}
