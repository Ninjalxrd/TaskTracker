//
//  EditViewController.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import UIKit

// MARK: - EditViewController
final class EditViewController: UIViewController, EditTaskPresenterOutput {

    // MARK: - Properties
    private let editView: EditView = .init()
    private let saveOverlay: CompactSaveOverlay = CompactSaveOverlay()
    private var currentTask: TaskEntity?
    var editPresenter: EditTaskPresenterInput!
    
    // MARK: - Initializers
    init(currentTask: TaskEntity?) {
        self.currentTask = currentTask
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
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
    
    // MARK: - Task Handling
    
    func saveTaskData() {
        guard let text = editView.textView.text, !text.isEmpty else { return }
        let (title, description) = editView.separateTitleWithDescription(from: text)
        guard let existingTask = currentTask else { return }
        
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
    
    func fetchTaskData() {
        guard let task = currentTask else { return }
        editPresenter.obtainTask(for: task.localId)
    }
    
    func setupForEditing(task: TaskEntity) {
        editView.configureCell(with: task)
    }
    
    // MARK: - UI Setup
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: Color.yellow ?? UIColor.yellow]
        appearance.largeTitleTextAttributes = [.foregroundColor: Color.yellow ?? UIColor.yellow]
        
        navigationController?.navigationBar.tintColor = Color.yellow
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance

        let doneButton = UIBarButtonItem(customView: editView.doneButton)
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func setupCallback() {
        editView.onSave = { [weak self] in
            self?.saveTaskData()
        }
    }
}
