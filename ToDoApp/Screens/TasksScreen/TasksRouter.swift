//
//  TasksRouter.swift
//  ToDoApp
//
//  Created by Павел on 18.03.2025.
//

import Foundation
import UIKit

protocol TasksRouterProtocol: AnyObject {
    func showTaskEditScreen(task: TaskEntity, animated: Bool)
    func presentActivityVC(activityVC: UIActivityViewController, animated: Bool)
    func showTaskDetail(for task: TaskEntity, animate: Bool)
}

final class TasksRouter: TasksRouterProtocol {
    
    weak var view: UIViewController!
    var detailVC: TaskDetailControllerInput!
    
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
        view.present(detailVC as! UIViewController, animated: true)
    }
}
