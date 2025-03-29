//
//  TasksView.swift
//  ToDoApp
//
//  Created by Павел on 18.03.2025.
//
// MARK: - TasksView

import UIKit

final class TasksView: UIView {
    
    // MARK: - Callbacks
    var onCellSelected: ((IndexPath) -> Void)?
    var textDidChange: ((String) -> Void)?
    
    // MARK: - Properties
    var countOfTasks = 0 {
        didSet {
            updateTableViewFooter()
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Sizes.tasksViewTitleLabelSize, weight: .bold)
        label.textColor = UIColor(named: "textColor")
        label.numberOfLines = 1
        label.text = "Задачи"
        return label
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Поиск"
        search.translatesAutoresizingMaskIntoConstraints = false
        search.backgroundImage = UIImage()
        search.delegate = self
        let searchIcon = UIImage(systemName: "magnifyingglass")?.withTintColor(Color.lightGray ?? .systemGray6, renderingMode: .alwaysOriginal)
        search.setImage(searchIcon, for: .search, state: .normal)
        
        let searchTextField = search.searchTextField
        searchTextField.backgroundColor = UIColor(named: "searchColor")
        searchTextField.textColor = UIColor(named: "textColor")
        searchTextField.layer.cornerRadius = Sizes.searchBarCornerRadius
        searchTextField.layer.masksToBounds = true
        searchTextField.font = .systemFont(ofSize: Sizes.searchBarTextFieldTextSize, weight: .medium)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: Sizes.searchBarTextFieldTextSize),
            .foregroundColor: Color.lightGray ?? .systemGray5
        ]
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Поиск", attributes: placeholderAttributes)
        addCancelButtonToKeyboard(textField: searchTextField)
        
        return search
    }()
    
    // MARK: - UI Setup Methods
    private func addCancelButtonToKeyboard(textField: UITextField) {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Sizes.toolbarHeight))
        toolBar.backgroundColor = UIColor(named: "otherColor")
        let cancelButton = UIBarButtonItem(
            image: UIImage(systemName: "keyboard.chevron.compact.down"),
            primaryAction: cancelAction)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.tintColor = Color.yellow
        toolBar.items = [flexibleSpace, cancelButton]
        textField.inputAccessoryView = toolBar
    }
    
    private lazy var cancelAction = UIAction { [weak self] _ in
        self?.endEditing(true)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, searchBar])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.small
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: TasksTableViewCell.identifier)
        tableView.backgroundView = activityIndicator
        return tableView
    }()
    
    // MARK: - Footer View
    private func createFooterView(countOfTasks: Int) -> UIView {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tasksTableView.bounds.width, height: Sizes.footerHeight))
        footer.backgroundColor = UIColor(named: "backgroundColor")
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Sizes.footerLabelSize, weight: .medium)
        label.textColor = UIColor(named: "textColor")
        label.text = "Всего задач: \(countOfTasks)"
        footer.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: footer.centerYAnchor)
        ])
        
        return footer
    }
    
    private func updateTableViewFooter() {
        let footerView = createFooterView(countOfTasks: countOfTasks)
        tasksTableView.tableFooterView = footerView
    }
    
    // MARK: - Activity Indicator
    lazy var activityIndicator: CustomActivityIndicator = {
        let indicator = CustomActivityIndicator()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(topStackView)
        addSubview(tasksTableView)
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.tasksViewTopStackViewConstant),
            topStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.tasksViewTopStackViewConstant),
            
            tasksTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Constants.tasksViewTableViewConstant),
            tasksTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.tasksViewTableViewConstant),
            tasksTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.tasksViewTableViewConstant),
            tasksTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: tasksTableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tasksTableView.centerYAnchor),
        ])
    }
}

// MARK: - Extensions with delegates

extension TasksView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCellSelected?(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Sizes.tableViewHeightForRow
    }
}

extension TasksView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textDidChange?(searchText)
    }
}
