//
//  DebounceSaveManager.swift
//  ToDoApp
//
//  Created by Павел on 26.03.2025.
//
import Foundation

final class DebounceSaveManager {
    
    static let shared = DebounceSaveManager()
    private var timer: Timer?
    private let debounceSaveStateInterval: TimeInterval = 0.5
    private let debounceSaveTaskInterval: TimeInterval = 1.5
    private var tasks: [TaskEntity] = []

    func scheduleSaveCompletedState(for task: TaskEntity, isCompleted: Bool, saveHandler: @escaping ([TaskEntity]) -> Void) {
        var updatedTask = task
        updatedTask.completed = isCompleted

        if let index = tasks.firstIndex(where: { $0.localId == task.localId }) {
            tasks[index] = updatedTask
        } else {
            tasks.append(updatedTask)
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: debounceSaveStateInterval, repeats: false) { [weak self] _ in
            guard let self else { return }
            saveHandler(self.tasks)
            self.tasks.removeAll()
        }
    }
    
    func scheduleSaveTask(saveHandler: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: debounceSaveTaskInterval, repeats: false) { _ in
            saveHandler()
        }
    }

    private init() { }
}

