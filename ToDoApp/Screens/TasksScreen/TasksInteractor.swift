//
//  TasksInteractor.swift
//  ToDoApp
//
//  Created by Павел on 18.03.2025.
//

import CoreData
import Foundation
import UIKit

    //MARK: - Protocols
protocol TasksInteractorInput {
    func obtainTasks()
    func updateCheckmarkState(with tasks: [TaskEntity])
    func deleteTask(task: TaskEntity)
    func searchTask(searchText: String)
    func getCountOfEntities() -> Int
}

protocol TasksInteractorOutput: AnyObject {
    func didObtainTasks(_ tasks: [TaskEntity])
    func didObtainFailure(_ error: Error)
}

final class TasksInteractor: NSObject, TasksInteractorInput {
    
    // MARK: - Properties
    weak var presenter: TasksInteractorOutput!
    var networkService: NetworkServiceInput!
    var coreDataManager: CoreDataManagerInput!
    private var fetchedResultsController: NSFetchedResultsController<Task>!
    private var searchFetchedResultsController: NSFetchedResultsController<Task>!
    
    // MARK: - Setup FetchedResultsController
    private func setupFetchedResultsController() {
        fetchedResultsController = coreDataManager.createFetchedResultsController()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Fetch error: \(error)")
        }
    }
    
    // MARK: - TasksInteractorInput Methods
    func obtainTasks() {
        setupFetchedResultsController()
        
        if let tasks = fetchedResultsController.fetchedObjects, !tasks.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.presenter.didObtainTasks(tasks.map { $0.toEntity() })
            }
            return
        }
        
        self.networkService.obtainTasks { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tasks):
                let tasksWithUUID = tasks.map { $0.toLocalEntity() }
                for task in tasksWithUUID {
                    self.coreDataManager.saveFetchedTask(with: task)
                }
                DispatchQueue.main.async {
                    self.presenter.didObtainTasks(tasksWithUUID)
                }
            case .failure(let error):
                self.presenter.didObtainFailure(error)
            }
        }
    }
    
    // MARK: - Search Functionality
    private func setupSearchFetchedResultsController(searchText: String) {
        searchFetchedResultsController = coreDataManager.createSearchFetchedResultsController(searchText: searchText)
        searchFetchedResultsController.delegate = self
        do {
            try searchFetchedResultsController.performFetch()
        } catch {
            print("Search fetch error: \(error)")
        }
    }
    
    func searchTask(searchText: String) {
        setupSearchFetchedResultsController(searchText: searchText)
        if let searchedTasks = searchFetchedResultsController.fetchedObjects, !searchedTasks.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.presenter.didObtainTasks(searchedTasks.map { $0.toEntity() })
            }
        }
    }
    
    func updateCheckmarkState(with tasks: [TaskEntity]) {
        coreDataManager.updateStatusOfTasks(with: tasks)
    }
    
    func deleteTask(task: TaskEntity) {
        coreDataManager.deleteTask(with: task)
    }
    
    func getCountOfEntities() -> Int {
        return coreDataManager.getCountOfEntities()
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TasksInteractor: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == fetchedResultsController {
            updateTasks(from: fetchedResultsController)
        } else if controller == searchFetchedResultsController {
            updateTasks(from: searchFetchedResultsController)
        }
    }
    
    private func updateTasks(from frc: NSFetchedResultsController<Task>) {
        if let tasks = frc.fetchedObjects {
            let taskEntities = tasks.map { task in
                TaskEntity(
                    localId: task.localId,
                    serverId: task.serverId != nil ? Int(task.serverId!) : nil,
                    title: task.title,
                    description: task.descriptionOfTask,
                    date: task.date,
                    completed: task.completed
                )
            }
            DispatchQueue.main.async { [weak self] in
                self?.presenter.didObtainTasks(taskEntities)
            }
        }
    }
}

