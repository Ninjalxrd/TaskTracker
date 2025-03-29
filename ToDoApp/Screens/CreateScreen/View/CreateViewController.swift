//
//  CreateEditTaskViewController.swift
//  ToDoApp
//
//  Created by Павел on 24.03.2025.
//

import UIKit

final class CreateEditTaskViewController: UIViewController, CreatePresenterOutput {

    private let createView: CreateView = .init()
    private let saveOverlay: CompactSaveOverlay = CompactSaveOverlay()
    var createPresenter: CreatePresenterInput!
    
    override func loadView() {
        super.loadView()
        view = createView
        createView.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDoneButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createView.textView.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createView.textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveTaskData()
    }
    
    func saveTaskData() {
        guard let text = createView.textView.text, text != "" else { return }
        let (title, description) = createView.separateTitleWithDescription(from: text)

            let newTask = TaskEntity(
                localId: UUID(),
                serverId: nil,
                title: title,
                description: description,
                date: Date.now,
                completed: false
            )
        
        createPresenter.saveNewTask(with: newTask)
        saveOverlay.show(in: createView, with: 1.5)
    }
    
    private func setupDoneButtonAction() {
        createView.onDoneButtonTapped = { [weak self] in
            guard let text = self?.createView.textView.text, text != "" else {
                self?.createPresenter.showAlert(
                    title: "Заметка не может быть пустой",
                    message: "Напишите что-нибудь"
                )
                return
            }
        }
    }
    
    
    private func setupNavigationBar() {
        let appearence = UINavigationBarAppearance()
        appearence.titleTextAttributes = [.foregroundColor: Color.yellow ?? UIColor.yellow]
        appearence.largeTitleTextAttributes = [.foregroundColor: Color.yellow ?? UIColor.yellow]
        
        navigationController?.navigationBar.tintColor = Color.yellow
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.compactAppearance = appearence

        let doneButton = UIBarButtonItem(customView: createView.doneButton)
        navigationItem.rightBarButtonItem = doneButton
    }
}
