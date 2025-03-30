//
//  CreateInteractorTasks.swift
//  ToDoApp
//
//  Created by Павел on 30.03.2025.
//

import XCTest
@testable import ToDoApp

class CreateInteractorTests: XCTestCase {
    
    var interactor: CreateTaskInteractor!
    var mockCoreData: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        mockCoreData = MockCoreDataManager()
        interactor = CreateTaskInteractor()
        interactor.coreDataManager = mockCoreData
    }
    
    func testSaveNewTask() {
        // Given
        let task = TaskEntity(localId: UUID(), title: "New Task", completed: false)
        
        // When
        interactor.saveTaskData(with: task)
        
        // Then
        XCTAssertTrue(mockCoreData.saveNewTaskCalled)
        XCTAssertEqual(mockCoreData.savedNewTask?.title, "New Task")
    }
}
