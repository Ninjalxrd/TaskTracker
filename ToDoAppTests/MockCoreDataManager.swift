//
//  MockCoreDataManager.swift
//  ToDoApp
//
//  Created by Павел on 30.03.2025.
//

import XCTest
@testable import ToDoApp
import CoreData

class MockCoreDataManager: CoreDataManagerInput {
    
    var stubTasks: [TaskEntity] = []
    var savedTasks: [TaskEntity] = []
    var stubTask: Task?
    
    var saveFetchedTaskCalled = false
    var saveNewTaskCalled = false
    var deleteTaskCalled = false
    var updateTaskCalled = false
    var savedNewTask: TaskEntity?
    var deletedTaskId: UUID?
    var updatedTask: TaskEntity?

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoApp")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
          return persistentContainer.viewContext
      }
      
      var backgroundContext: NSManagedObjectContext {
          return persistentContainer.newBackgroundContext()
      }
    
    func createFetchedResultsController() -> NSFetchedResultsController<Task> {
        let request = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    func createSearchFetchedResultsController(searchText: String) -> NSFetchedResultsController<Task> {
        return createFetchedResultsController()
    }
    
    func saveFetchedTask(with task: TaskEntity) {
        saveFetchedTaskCalled = true
        savedTasks.append(task)
        
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.performAndWait {
            let newTask = Task(context: backgroundContext)
            newTask.localId = task.localId
            newTask.title = task.title
            newTask.completed = task.completed
            
            do {
                try backgroundContext.save()
            } catch {
                print("Error saving mock task: \(error)")
            }
        }
    }
    
    func saveNewTask(with task: TaskEntity) {
        saveNewTaskCalled = true
        savedNewTask = task
    }
    
    func obtainTask(for taskId: UUID, completion: @escaping (Result<Task, Error>) -> Void) {
        if let task = stubTask {
            completion(.success(task))
        } else {
            completion(.failure(NSError(domain: "Test", code: 0)))
        }
    }
    
    func updateStatusOfTasks(with tasks: [TaskEntity]) {
        updatedTask = tasks.first
    }
    
    func updateTask(with task: TaskEntity) {
        updateTaskCalled = true
        updatedTask = task
    }
    
    func deleteTask(with task: TaskEntity) {
        deleteTaskCalled = true
        deletedTaskId = task.localId
    }
    
    func getCountOfEntities() -> Int {
        return stubTasks.count
    }
}
