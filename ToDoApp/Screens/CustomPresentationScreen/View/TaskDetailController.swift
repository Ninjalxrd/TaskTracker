//
//  TaskDetailController.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import UIKit

// MARK: - TaskDetailControllerInput Protocol
protocol TaskDetailControllerInput {
    func setupWithTask(_ task: TaskEntity)
    
    func setupModalStyle(_ presentationStyle: UIModalPresentationStyle,
                         _ transitionStyle: UIModalTransitionStyle)
}

// MARK: - TaskDetailController
final class TaskDetailController: UIViewController, TaskDetailControllerInput {
    
    // MARK: - Properties
    var presenter: TasksPresenterInput!
    var currentTask: TaskEntity?
    
    private var taskDetailView: TaskDetailView {
        view as! TaskDetailView
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = TaskDetailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        setupCallbacks()
    }
    
    // MARK: - Setup Methods
    private func setupCallbacks() {
        taskDetailView.onDismissButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        taskDetailView.onDownSwipe = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        taskDetailView.onDeleteButtonTapped = { [weak self] in
            guard let self, let task = self.currentTask else { return }
            presenter.deleteTask(task: task)
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - TaskDetailControllerInput
    func setupModalStyle(_ presentationStyle: UIModalPresentationStyle,
                         _ transitionStyle: UIModalTransitionStyle) {
        self.modalTransitionStyle = transitionStyle
        self.modalPresentationStyle = presentationStyle
    }
    
    func setupWithTask(_ task: TaskEntity) {
        currentTask = task
        taskDetailView.setupWithTask(task)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension TaskDetailController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return CustomHeightPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
