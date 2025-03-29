//
//  TaskDetailController.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import UIKit

protocol TaskDetailControllerInput {
    func setupWithTask(_ task: TaskEntity)
    func setupModalStyle(_ presentationStyle : UIModalPresentationStyle, _ transitionStyle: UIModalTransitionStyle)
}

final class TaskDetailController: UIViewController, TaskDetailControllerInput {
    
    var presenter: TasksPresenterInput!
    var currentTask: TaskEntity?
    private var taskDetailView: TaskDetailView {
        view as! TaskDetailView
    }
    
    override func loadView() {
        view = TaskDetailView()
    }
    
    override func viewDidLoad() {
        transitioningDelegate = self
        setupCallbacks()
    }
    
    func setupCallbacks() {
        taskDetailView.onDismissButtonTapped = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        taskDetailView.onDownSwipe = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        taskDetailView.onDeleteButtonTapped = { [weak self] in
            guard let self else { return }
            presenter.deleteTask(task: self.currentTask!)
            self.dismiss(animated: true)
        }
    }
    
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

// MARK: Conforming UIViewControllerTransitioningDelegate protocol
extension TaskDetailController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomHeightPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
