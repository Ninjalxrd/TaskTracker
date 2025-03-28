//
//  DateFormatterHelper.swift
//  ToDoApp
//
//  Created by Павел on 24.03.2025.
//
import Foundation

struct DateFormatterHelper {
    
    static let taskDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter
    }()
    
    static func formattedCurrentDate() -> String {
        return taskDateFormatter.string(from: Date())
    }
    
    static func formattedRecievedDate(date: Date) -> String {
        return taskDateFormatter.string(from: date)
    }
}
