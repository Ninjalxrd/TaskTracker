//
//  TaskDetailController.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import UIKit

final class TaskDetailController: UIViewController {
    
    private var taskDetailView: TaskDetailView {
        view as! TaskDetailView
    }
    
    override func loadView() {
        view = TaskDetailView()
    }
    
    override func viewDidLoad() {
        transitioningDelegate = self
        
        taskDetailView.dismissButton.addAction(UIAction { _  in
            self.dismiss(animated: true, completion: nil)
        }, for: .touchUpInside)
    }
    
    func setupWithTodo(_ task: TaskEntity) {
        taskDetailView.setupWithTask(task)
    }
    
    /*
     statisticView.presentTodoInfoScreen = { todo in
                 let todoDetailScreen = TodoDetailController()
                 todoDetailScreen.setupWithTodo(todo)
                 todoDetailScreen.modalPresentationStyle = .custom
                 todoDetailScreen.modalTransitionStyle = .coverVertical
                 
                 self.present(todoDetailScreen, animated: true)
             }
     */
}

// MARK: Conforming UIViewControllerTransitioningDelegate protocol
extension TaskDetailController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomHeightPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
