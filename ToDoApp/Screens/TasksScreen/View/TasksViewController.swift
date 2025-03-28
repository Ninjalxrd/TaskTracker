    //
    //  TasksViewController.swift
    //  ToDoApp
    //
    //  Created by Павел on 18.03.2025.
    //

    import UIKit

    final class TasksViewController: UIViewController, TasksPresenterOutput {
        private let tasksView: TasksView = .init()
        var tableViewDataSource: UITableViewDiffableDataSource<Int, TaskEntity>?
        var presenter: TasksPresenterInput!
        
        override func loadView() {
            super.loadView()
            view = tasksView
            tasksView.backgroundColor = UIColor(named: "backgroundColor")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            configureDataSource()
            tasksView.tasksTableView.dataSource = tableViewDataSource
            setupTabBar()
            setupOnCellSelected()
            setupSearchBar()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.fetchTasks()
            setupCountOfTasks()
        }

        
        private func setupTabBar() {
            tabBarController?.tabBar.tintColor = Color.yellow
            tabBarController?.tabBar.backgroundColor = UIColor(named: "otherColor")
            tabBarController?.tabBar.unselectedItemTintColor = Color.lightGray
        }
        
        func configureDataSource() {
            tableViewDataSource = UITableViewDiffableDataSource(tableView: tasksView.tasksTableView,
                                                                cellProvider: {
                [weak self] tableView, indexPath, task in
                let cell = tableView.dequeueReusableCell(withIdentifier: TasksTableViewCell.identifier, for: indexPath)
                as! TasksTableViewCell
                cell.configureCell(with: task)
                self?.setupCheckmarkButton(for: cell, task: task)
                self?.setupInteractionMenu(for: cell, task: task)
                return cell
            })
        }
        
        func updateDataSource(with tasks: [TaskEntity]) {
            var snapshot = NSDiffableDataSourceSnapshot<Int, TaskEntity>()
            snapshot.appendSections([0])
            snapshot.appendItems(tasks)
            tableViewDataSource?.apply(snapshot, animatingDifferences: false)
        }
        
        func setupOnCellSelected() {
            tasksView.onCellSelected = { [weak self] indexPath in
                let selectedTask = self?.tableViewDataSource?.itemIdentifier(for: indexPath)
                guard let selectedTask else { return }
                self?.presenter.didSelectTask(task: selectedTask)
            }
        }
        
        func setupInteractionMenu(for cell: TasksTableViewCell, task: TaskEntity) {
            cell.onEditAction = { [weak self] in
                self?.presenter.editTask(task: task)
            }
            
            cell.onShareAction = { [weak self] in
                guard let self else { return }
                self.presenter.shareTask(task: task, view: self.tasksView)
                
            }
            
            cell.onDeleteAction = { [weak self] in
                self?.presenter.deleteTask(task: task)
            }
        }
        
        func setupCheckmarkButton(for cell: TasksTableViewCell, task: TaskEntity) {
            cell.onUpdateCheckmarkButton = { [weak self] isCompleted in
                guard let self else { return }
                self.presenter.updateCheckmarkState(with: task, isCompleted: isCompleted)
            }
        }
        
        func setupSearchBar() {
            tasksView.textDidChange = {[weak self] searchText in
                self?.presenter.searchTask(searchText: searchText)
            }
        }
        
        func setupCountOfTasks() {
            tasksView.countOfTasks = presenter.getCountOfEntities()
        }

        func getTasks() -> [TaskEntity] {
            return tableViewDataSource?.snapshot().itemIdentifiers ?? []
        }
    }

