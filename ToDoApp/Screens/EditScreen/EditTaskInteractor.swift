//
//  EditTaskInteractor.swift
//  ToDoApp
//
//  Created by Павел on 24.03.2025.
//

import Foundation

protocol EditTaskInteractorInput {
    func obtainTaskData(for taskId: UUID)
    func updateTaskData(with task: TaskEntity)
}

protocol EditTaskInteractorOutput {
    func didObtainTask(_ task: TaskEntity)
}

final class EditTaskInteractor: EditTaskInteractorInput {
    
    var coreDataManager: CoreDataManagerInput!
    var presenter: EditTaskInteractorOutput!
    
    func obtainTaskData(for taskId: UUID) {
        
        coreDataManager.obtainTask(for: taskId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let task):
                let taskEntity = task.toEntity()
                DispatchQueue.main.async {
                    self.presenter.didObtainTask(taskEntity)
                }
                return
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    
    func updateTaskData(with task: TaskEntity) {
        coreDataManager.updateTask(with: task)
    }
}


