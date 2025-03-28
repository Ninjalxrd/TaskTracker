//
//  CreateEditTaskRouter.swift
//  ToDoApp
//
//  Created by Павел on 25.03.2025.
//

import UIKit

protocol CreateEditTaskRouterProtocol {
    func showAlert(title: String, message: String)
}

final class CreateEditTaskRouter: CreateEditTaskRouterProtocol {
    
    weak var view: UIViewController!
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Хорошо", style: .cancel)
        alert.addAction(alertAction)
        view.present(alert, animated: true)
    }
}
