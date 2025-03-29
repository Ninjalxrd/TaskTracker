//
//  Task.swift
//  ToDoApp
//
//  Created by Павел on 19.03.2025.
//

import Foundation

struct TasksResponse: Hashable, Codable {
    let todos: [NetworkTask]
    let total: Int
    let limit: Int
}

struct NetworkTask: Hashable, Codable {
    var serverId: Int?
    var title: String?
    var description: String?
    var date: Date?
    var completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case serverId = "id"
        case title = "todo"
        case description
        case date
        case completed
    }
    
    ///TaskEntity использует именно id как уникальный идентификатор
    func hash(into hasher: inout Hasher) {
        hasher.combine(serverId)
    }
}

struct TaskEntity: Hashable {
    var localId: UUID
    var serverId: Int?
    var title: String?
    var description: String?
    var date: Date?
    var finishedAt: Date?
    var completed: Bool
}


extension NetworkTask {
    func toLocalEntity() -> TaskEntity {
        return TaskEntity(
            localId: UUID(),
            serverId: serverId,
            title: title,
            description: description,
            date: date,
            completed: completed
        )
    }
}
