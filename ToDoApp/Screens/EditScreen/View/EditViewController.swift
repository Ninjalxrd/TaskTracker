//
//  EditViewController.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import UIKit

final class EditViewController: UIViewController, EditTaskPresenterOutput {

    private let editView: EditView = .init()
    private let saveOverlay: CompactSaveOverlay = CompactSaveOverlay()
    private var currentTask: TaskEntity?
    var editPresenter: EditTaskPresenterInput!
    
    init(currentTask: TaskEntity?) {
        self.currentTask = currentTask
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = editView
        editView.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTaskData()
        setupNavigationBar()
        setupCallback()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveTaskData()
    }
    
    func saveTaskData() {
        guard let text = editView.textView.text, text != "" else { return }
        let (title, description) = editView.separateTitleWithDescription(from: text)
        guard let existingTask = currentTask else {
            return
        }
        let updatedTask = TaskEntity(
            localId: existingTask.localId,
            serverId: existingTask.serverId,
            title: title,
            description: description,
            date: existingTask.date,
            completed: existingTask.completed
        )
        currentTask = updatedTask
        editPresenter.updateTaskData(with: updatedTask)
        saveOverlay.show(in: editView, with: 1.5)
    }
    
    private func setupNavigationBar() {
        let appearence = UINavigationBarAppearance()
        appearence.titleTextAttributes = [.foregroundColor: Color.yellow ?? UIColor.yellow]
        appearence.largeTitleTextAttributes = [.foregroundColor: Color.yellow ?? UIColor.yellow]
        
        navigationController?.navigationBar.tintColor = Color.yellow
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.compactAppearance = appearence

        let doneButton = UIBarButtonItem(customView:
                                            editView.doneButton)
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func fetchTaskData() {
        guard let task = currentTask else { return }
        let taskId = task.localId
        editPresenter.obtainTask(for: taskId)
    }
    
    func setupForEditing(task: TaskEntity) {
        editView.configureCell(with: task)
    }

    func setupCallback() {
        editView.onSave = { [weak self] in
            guard let self else { return }
            self.saveTaskData()
        }
    }
}

