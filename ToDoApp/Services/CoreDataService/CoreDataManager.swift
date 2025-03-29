//
//  CoreDataManager.swift
//  ToDoApp
//
//  Created by Павел on 23.03.2025.
//

import CoreData

// MARK: - Protocol

protocol CoreDataManagerInput {
    func createFetchedResultsController() -> NSFetchedResultsController<Task>
    func createSearchFetchedResultsController(searchText: String) -> NSFetchedResultsController<Task>
    func saveFetchedTask(with task: TaskEntity)
    func saveNewTask(with task: TaskEntity)
    func obtainTask(for taskId: UUID, completion: @escaping (Result<Task,Error>) -> Void)
    func updateStatusOfTasks(with tasks: [TaskEntity])
    func updateTask(with task: TaskEntity)
    func deleteTask(with task: TaskEntity)
    func getCountOfEntities() -> Int
}

// MARK: CoreData Manager

class CoreDataManager: CoreDataManagerInput {
    
    static let shared = CoreDataManager()
    
    private init() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoApp") 
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveBackgroundContext () {
        let context = persistentContainer.newBackgroundContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - FetchedResultsControllers
    
    /// General FRC
    
    func createFetchedResultsController() -> NSFetchedResultsController<Task> {
        let taskFetchRequest = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        taskFetchRequest.sortDescriptors = [sortDescriptor]
        
        let resultController = NSFetchedResultsController(fetchRequest: taskFetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return resultController
    }
    
    ///FRC for searching
    
    func createSearchFetchedResultsController(searchText: String) -> NSFetchedResultsController<Task> {
        let searchFetchRequest = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        searchFetchRequest.sortDescriptors = [sortDescriptor]
        let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        let descriptionPredicate = NSPredicate(format: "descriptionOfTask CONTAINS[cd] %@", searchText)
        searchFetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, descriptionPredicate])
        
        let searchController = NSFetchedResultsController(fetchRequest: searchFetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return searchController
    }
    
    // MARK: - CRUD Operations
    
    /// First save from network
    
    func saveFetchedTask(with task: TaskEntity) {
        let backgroundContext = backgroundContext
        backgroundContext.perform {
            let fetchRequest = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "localId == %@", task.localId as CVarArg)
            
            do {
                let existingTasks = try backgroundContext.fetch(fetchRequest)
                let taskEntity: Task
                if let existingTask = existingTasks.first {
                    taskEntity = existingTask
                } else {
                    taskEntity = Task(context: backgroundContext)
                    taskEntity.localId = task.localId
                }

                taskEntity.title = task.title
                taskEntity.completed = task.completed
                
                if let description = task.description, !description.isEmpty {
                    taskEntity.descriptionOfTask = description
                } else {
                    taskEntity.descriptionOfTask = "Some description from JSON"
                }

                if let date = task.date {
                    taskEntity.date = date
                } else {
                    taskEntity.date = Date.now
                }
                try backgroundContext.save()
            } catch {
                print("Error saving task: \(error)")
            }
        }
    }
    
    /// Saving new task
    
    func saveNewTask(with task: TaskEntity) {
        let backgroundContext = backgroundContext
        backgroundContext.perform {
            let taskEntity = Task(context: backgroundContext)
            taskEntity.serverId = task.serverId != nil ? Int32(task.serverId!) : nil
            taskEntity.localId = task.localId
            taskEntity.title = task.title
            taskEntity.completed = task.completed
            taskEntity.descriptionOfTask = task.description
            taskEntity.date = task.date
            
            do {
                try backgroundContext.save()
            } catch {
                print("Error saving new task: \(error)")
            }
        }
    }

    func obtainTask(for taskId: UUID, completion: @escaping (Result<Task, Error>) -> Void) {
        let viewContext = viewContext
        viewContext.perform {
            let taskRequest = Task.fetchRequest()
            taskRequest.predicate = NSPredicate(format: "localId == %@", taskId as CVarArg)
            
            do {
                let storedTasks = try viewContext.fetch(taskRequest)
                if let task = storedTasks.first(where: { $0.localId == taskId }) {
                    DispatchQueue.main.async {
                        completion(.success(task))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    ///update completed status
    
    func updateStatusOfTasks(with tasks: [TaskEntity]) {
        let backgroundContext = backgroundContext
        backgroundContext.perform {
            let fetchRequest = Task.fetchRequest()
            do {
                let storedTasks = try backgroundContext.fetch(fetchRequest)
                for storedTask in storedTasks {
                    if let updatedTask = tasks.first(where: { $0.localId == storedTask.localId }) {
                        storedTask.completed = updatedTask.completed
                    }
                }
                try backgroundContext.save()
            } catch {
                print("error with update data \(error)")
            }
        }
    }
    
    func updateTask(with task: TaskEntity) {
        let backgroundContext = backgroundContext
        backgroundContext.perform {
            let fetchRequest = Task.fetchRequest()
            
            do {
                let storedTasks = try backgroundContext.fetch(fetchRequest)
                
                if let updatedTask = storedTasks.first(where: { $0.localId == task.localId }) {
                    updatedTask.title = task.title
                    updatedTask.descriptionOfTask = task.description
                    updatedTask.completed = task.completed
                    updatedTask.date = task.date
                }
                do {
                    try backgroundContext.save()
                } catch {
                    print("error with update task: \(error)")
                }
            } catch {
                print("error with updating task: \(task)")
            }
        }
    }
    
    func deleteTask(with task: TaskEntity) {
        let backgroundContext = backgroundContext
        backgroundContext.perform {
            let fetchRequest = Task.fetchRequest()
            let predicate = NSPredicate(format: "localId == %@", task.localId as CVarArg)
            fetchRequest.predicate = predicate
            
            do {
                let tasks = try backgroundContext.fetch(fetchRequest)
                if let taskToDelete = tasks.first {
                    backgroundContext.delete(taskToDelete)
                    do {
                        try backgroundContext.save()
                    } catch {
                        print("error with delete task: \(error)")
                    }
                }
            } catch {
                print("Error deleting task: \(error)")
            }
        }
    }
    
    // MARK: - Utility Methods

    func getCountOfEntities() -> Int {
        let context = backgroundContext
        let fetchRequest = Task.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("Error counting entities: \(error)")
            return 0
        }
    }
}
