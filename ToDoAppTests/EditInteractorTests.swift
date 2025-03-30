//
//  EditInteractorTests.swift
//  ToDoApp
//
//  Created by Павел on 30.03.2025.
//

import XCTest
import CoreData
@testable import ToDoApp


class EditInteractorTests: XCTestCase {
    
    var interactor: EditTaskInteractor!
    var mockPresenter: MockEditPresenter!
    var mockCoreData: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockEditPresenter()
        mockCoreData = MockCoreDataManager()
        interactor = EditTaskInteractor()
        interactor.presenter = mockPresenter
        interactor.coreDataManager = mockCoreData
    }
    
    func testObtainTaskData() {
        // Given
        let taskId = UUID()
        let testTask = Task(context: mockCoreData.viewContext)
        testTask.localId = taskId
        testTask.title = "Test Task"
        testTask.date = Date()
        
        mockCoreData.viewContext.performAndWait {
            try? mockCoreData.viewContext.save()
        }
        
        mockCoreData.stubTask = testTask
        
        let expectation = self.expectation(description: "Task Fetching")
        
        // When
        interactor.obtainTaskData(for: taskId)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.mockPresenter.didObtainTaskCalled)
            XCTAssertEqual(self.mockPresenter.receivedTask?.localId, taskId)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateTask() {
        // Given
        let task = TaskEntity(localId: UUID(), title: "Updated", completed: false)
        
        // When
        interactor.updateTaskData(with: task)
        
        // Then
        XCTAssertTrue(mockCoreData.updateTaskCalled)
        XCTAssertEqual(mockCoreData.updatedTask?.title, "Updated")
    }
}

class MockEditPresenter: EditTaskInteractorOutput {
    var didObtainTaskCalled = false
    var receivedTask: TaskEntity?
    
    func didObtainTask(_ task: TaskEntity) {
        didObtainTaskCalled = true
        receivedTask = task
    }
}
