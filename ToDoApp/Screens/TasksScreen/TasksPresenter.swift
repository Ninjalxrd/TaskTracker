//
//  TaskPresenter.swift
//  ToDoApp
//
//  Created by Павел on 18.03.2025.
//

import Foundation
import UIKit

///Те методы, которые реализуются внутри этого класса и должны быть доступны снаружи(другие классы вызывают методы, обращаясь к экземпляру
///класса (протокола)protocol TasksPresenterInput: AnyObject {
protocol TasksPresenterInput: AnyObject {
    func updateDataSource(with tasks: [TaskEntity])
    func fetchTasks()
    func updateCheckmarkState(with task: TaskEntity, isCompleted: Bool)
    func didSelectTask(task: TaskEntity)
    func editTask(task: TaskEntity)
    func deleteTask(task: TaskEntity)
    func shareTask(task: TaskEntity, view: UIView)
    func searchTask(searchText: String)
    func getCountOfEntities() -> Int
}
///То, что он выводит, то, как он общается в viewController
///Т.е здесь находятся методы, которые находятся в других классах, внутри которых вызывается наш класс
protocol TasksPresenterOutput: AnyObject {
    func configureDataSource()
    func updateDataSource(with tasks: [TaskEntity])
}

final class TasksPresenter: TasksPresenterInput {
    weak var viewController: TasksPresenterOutput!
    var interactor: TasksInteractorInput!
    var router: TasksRouterProtocol!
    
    func updateDataSource(with tasks: [TaskEntity]) {
        viewController.updateDataSource(with: tasks)
    }
    
    func fetchTasks() {
        interactor.obtainTasks()
    }
    
    func updateCheckmarkState(with task: TaskEntity, isCompleted: Bool) {
        DebounceSaveManager.shared.scheduleSaveCompletedState(for: task, isCompleted: isCompleted) { [weak self] tasksToSave in
            self?.interactor.updateCheckmarkState(with: tasksToSave)
        }
    }
    
    func didSelectTask(task: TaskEntity) {
        router.showTaskEditScreen(task: task, animated: true)
    }
    
    func editTask(task: TaskEntity) {
        router.showTaskEditScreen(task: task, animated: true)
    }
    
    func deleteTask(task: TaskEntity) {
        interactor.deleteTask(task: task)
    }
    
    func shareTask(task: TaskEntity, view: UIView) {
        let text = "Задача: \(task.title ?? "")\nОписание: \(task.description ?? "")"
        let dateString = DateFormatterHelper.formattedRecievedDate(date: task.date ?? Date())
        
        let items: [String] = [
            text,
            "Заметка создана: \(dateString)"
        ]
        
        let activityVC = UIActivityViewController(activityItems: items,
                                                  applicationActivities: nil)
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX,
                                        y: view.bounds.midY,
                                        width: 0,
                                        height: 0)
        }
        
        router.presentActivityVC(activityVC: activityVC, animated: true)
    }
    
    func searchTask(searchText: String) {
        interactor.searchTask(searchText: searchText)
    }
    
    func getCountOfEntities() -> Int {
        interactor.getCountOfEntities()
    }
}

extension TasksPresenter: TasksInteractorOutput {
    
    func didObtainTasks(_ tasks: [TaskEntity]) {
        updateDataSource(with: tasks)
    }
    
    func didObtainFailure(_ error: any Error) {
        print("failure with obtain from network \(error)")
    }
    
}
 
