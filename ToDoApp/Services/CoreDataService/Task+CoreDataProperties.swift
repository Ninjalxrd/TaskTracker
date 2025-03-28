//
//  Task+CoreDataProperties.swift
//  ToDoApp
//
//  Created by Павел on 25.03.2025.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var date: Date?
    @NSManaged public var descriptionOfTask: String?
    @NSManaged public var localId: UUID
    @NSManaged public var primitiveServerId: NSNumber?
    @NSManaged public var title: String?
    
    var serverId: Int32? {
        get { primitiveServerId?.int32Value }
        set { primitiveServerId = newValue != nil ? NSNumber(value: newValue!) : nil }
    }

}

extension Task : Identifiable {

}
