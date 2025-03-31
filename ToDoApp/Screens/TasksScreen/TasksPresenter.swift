//
//  TaskPresenter.swift
//  ToDoApp
//
//  Created by Павел on 18.03.2025.
//

import Foundation
import UIKit

    // MARK: - Protocols
protocol TasksPresenterInput: AnyObject {
    func fetchTasks()
    func updateCheckmarkState(with task: TaskEntity, isCompleted: Bool)
    func didSelectTask(task: TaskEntity)
    func editTask(task: TaskEntity)
    func deleteTask(task: TaskEntity)
    func shareTask(task: TaskEntity, view: UIView)
    func searchTask(searchText: String)
    func showTaskDetail(for task: TaskEntity, animate: Bool)
    func getCountOfEntities() -> Int
}

protocol TasksPresenterOutput: AnyObject {
    func configureDataSource()
    func updateDataSource(with tasks: [TaskEntity])
    func setupCountOfTasks()
    func setupSearchBar()
}

// MARK: - TasksPresenterInput Implementation
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
        var updatedTask = task
        updatedTask.completed = isCompleted
        updatedTask.finishedAt = isCompleted ? Date.now : nil
        interactor.updateCheckmarkState(with: updatedTask)
    }
    
    // MARK: - Task Selection and Navigation
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
    
    func showTaskDetail(for task: TaskEntity, animate: Bool) {
        router.showTaskDetail(for: task, animate: animate)
    }
    
    func searchTask(searchText: String) {
        interactor.searchTask(searchText: searchText)
    }
    
    func getCountOfEntities() -> Int {
        interactor.getCountOfEntities()
    }
}

// MARK: - TasksInteractorOutput Implementation
extension TasksPresenter: TasksInteractorOutput {
    
    func didObtainTasks(_ tasks: [TaskEntity]) {
        updateDataSource(with: tasks)
    }
    
    func didObtainFailure(_ error: any Error) {
        print("Failure with obtain from network: \(error)")
    }
}

