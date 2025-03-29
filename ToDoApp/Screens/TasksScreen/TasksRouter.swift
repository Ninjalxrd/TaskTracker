//
//  TasksRouter.swift
//  ToDoApp
//
//  Created by Павел on 18.03.2025.
//

import Foundation
import UIKit

    //MARK: - Protocol

protocol TasksRouterProtocol: AnyObject {
    func showTaskEditScreen(task: TaskEntity, animated: Bool)
    func presentActivityVC(activityVC: UIActivityViewController, animated: Bool)
    func showTaskDetail(for task: TaskEntity, animate: Bool)
}

final class TasksRouter: TasksRouterProtocol {
    
    // MARK: - Properties
    weak var view: UIViewController!
    var detailVC: TaskDetailControllerInput!
    
    // MARK: - Navigation Methods
    func showTaskEditScreen(task: TaskEntity, animated: Bool) {
        let editTaskVC = EditTaskAssembly.buildScreen(task: task)
        view.navigationController?.pushViewController(editTaskVC, animated: animated)
    }
    
    func presentActivityVC(activityVC: UIActivityViewController, animated: Bool) {
        view.present(activityVC, animated: animated)
    }
    
    func showTaskDetail(for task: TaskEntity, animate: Bool) {
        detailVC.setupWithTask(task)
        detailVC.setupModalStyle(.custom, .coverVertical)
        if let detailViewController = detailVC as? UIViewController {
            view.present(detailViewController, animated: animate)
        }
    }
}

