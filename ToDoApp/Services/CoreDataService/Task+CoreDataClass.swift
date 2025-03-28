//
//  Task+CoreDataClass.swift
//  ToDoApp
//
//  Created by Павел on 25.03.2025.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {

}

extension Task {
    func toEntity() -> TaskEntity {
        return TaskEntity(localId: self.localId,
                          serverId: self.serverId != nil ? Int(self.serverId!) : nil,
                          title: self.title,
                          description: self.descriptionOfTask,
                          date: self.date,
                          completed: self.completed)
    }
}
