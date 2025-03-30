//
//  TasksInteractorTests.swift
//  ToDoApp
//
//  Created by Павел on 30.03.2025.
//

import XCTest
import CoreData
@testable import ToDoApp

class TasksInteractorTests: XCTestCase {
    
    var interactor: TasksInteractor!
    var mockPresenter: MockTasksPresenter!
    var mockCoreData: MockCoreDataManager!
    var mockNetwork: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockTasksPresenter()
        mockCoreData = MockCoreDataManager()
        mockNetwork = MockNetworkService()
        
        interactor = TasksInteractor()
        interactor.presenter = mockPresenter
        interactor.coreDataManager = mockCoreData
        interactor.networkService = mockNetwork
    }
    
    func testObtainTasksWithLocalData() {
        // Given
        let testTask = TaskEntity(
            localId: UUID(),
            title: "Test",
            description: "Test Description",
            date: Date(),
            completed: true
        )
        
        mockCoreData.saveFetchedTask(with: testTask)
        
        let expectation = self.expectation(description: "Data Fetching")
        
        // When
        interactor.obtainTasks()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.mockPresenter.didObtainTasksCalled)
            XCTAssertEqual(self.mockPresenter.receivedTasks?.count, 1)
            XCTAssertEqual(self.mockPresenter.receivedTasks?.first?.title, "Test")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testObtainTasksWithNetworkFallback() {
        // Given
        mockCoreData.stubTasks = []
        let testTask = NetworkTask(serverId: 1, title: "Test Title", description: "Desc", date: nil, completed: false)
        mockNetwork.stubResult = .success([testTask])
        
        // When
        interactor.obtainTasks()
        
        // Then
        XCTAssertTrue(mockCoreData.saveFetchedTaskCalled)
        XCTAssertEqual(mockCoreData.savedTasks.count, 1)
    }
    
    func testDeleteTask() {
        // Given
        let task = TaskEntity(localId: UUID(), completed: false)
        
        // When
        interactor.deleteTask(task: task)
        
        // Then
        XCTAssertTrue(mockCoreData.deleteTaskCalled)
        XCTAssertEqual(mockCoreData.deletedTaskId, task.localId)
    }
}

// MARK: - Mock Classes
class MockTasksPresenter: TasksInteractorOutput {
    var didObtainTasksCalled = false
    var receivedTasks: [TaskEntity]?
    var receivedError: Error?
    
    func didObtainTasks(_ tasks: [TaskEntity]) {
        didObtainTasksCalled = true
        receivedTasks = tasks
    }
    
    func didObtainFailure(_ error: Error) {
        receivedError = error
    }
}

class MockNetworkService: NetworkServiceInput {
    var stubResult: Result<[NetworkTask], Error> = .success([])
    
    func obtainTasks(completion: @escaping (Result<[NetworkTask], Error>) -> Void) {
        completion(stubResult)
    }
}
