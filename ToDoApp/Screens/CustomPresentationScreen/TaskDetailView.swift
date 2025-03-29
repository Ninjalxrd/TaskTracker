//
//  TaskDetailView.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import UIKit

final class TaskDetailView: UIView {
    
    private lazy var dayAndMonthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        formatter.locale = .current
        return formatter
    }()
    
    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = .current
        return formatter
    }()
    
    private lazy var distanceCompanentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = Sizes.blurViewCornerRadius
        return view
    }()
    
    private(set) lazy var deleteTaskButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = Sizes.blurViewCornerRadius
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.setTitle("Удалить", for: .normal)
        return button
    }()
    
    private lazy var taskTitle: UILabel = {
        let title = UILabel()
        title.font = .boldSystemFont(ofSize: 17)
        title.textColor = .label
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private(set) lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "backgroundColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleAndCrossButtonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            taskTitle,
            dismissButton
        ])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        return stack
    }()
    
    // MARK: Info about begining task
    private lazy var beginedAtTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 17)
        title.textColor = .secondaryLabel
        title.text = "Created"
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var dayOfCreatingLabel: UILabel = {
        let title = UILabel()
        title.font = .boldSystemFont(ofSize: 15)
        title.textColor = .label
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var timeOfCreatingLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14)
        title.textColor = .secondaryLabel
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    // MARK: Info about finishing task
    private lazy var finishedAtTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 17)
        title.textColor = .secondaryLabel
        title.text = "Completed"
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var dayOfFinishingLabel: UILabel = {
        let title = UILabel()
        title.font = .boldSystemFont(ofSize: 15)
        title.textColor = .label
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var timeOfFinishingLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14)
        title.textColor = .secondaryLabel
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    // MARK: Time stacks
    private lazy var createdAtDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            beginedAtTitle,
            dayOfCreatingLabel,
            timeOfCreatingLabel
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var finishedAtDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            finishedAtTitle,
            dayOfFinishingLabel,
            timeOfFinishingLabel
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .trailing
        return stack
    }()
    
    private lazy var timeOfDoingTask: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14)
        title.textColor = .secondaryLabel
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var taskDateStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            createdAtDataStackView,
            finishedAtDataStackView
        ])
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var firstSeparator: UIView = {
        getViewSeparator()
    }()
    
    private lazy var secondSeparator: UIView = {
        getViewSeparator()
    }()
    
    // MARK: DataStackView
    
    private lazy var dateStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleAndCrossButtonStackView,
            taskDateStackView,
            deleteTaskButton
        ])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.spacing = 25
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithTask(_ task: TaskEntity) {
        self.taskTitle.text = task.title
        
        dayOfCreatingLabel.text = dayAndMonthDateFormatter.string(from: task.date ?? Date.now)
        timeOfCreatingLabel.text = timeFormatter.string(from: task.date ?? Date.now)
        
//        dayOfFinishingLabel.text = dayAndMonthDateFormatter.string(from: todo.finishedAt!)
//        timeOfFinishingLabel.text = timeFormatter.string(from: todo.finishedAt!)
        
//        timeOfDoingTask.text = distanceCompanentsFormatter.string(from: todo.createdAt.distance(to: todo.finishedAt!))
    }
}

private extension TaskDetailView {
    
    func setup() {
        
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(bgView)
        bgView.addSubview(dateStackView)
        bgView.addSubview(timeOfDoingTask)
        bgView.addSubview(firstSeparator)
        bgView.addSubview(secondSeparator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            bgView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
        
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 25),
            dateStackView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 25),
            dateStackView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            timeOfDoingTask.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeOfDoingTask.centerYAnchor.constraint(equalTo: taskDateStackView.centerYAnchor),
            
            firstSeparator.leadingAnchor.constraint(equalTo: dayOfCreatingLabel.trailingAnchor, constant: 10),
            firstSeparator.trailingAnchor.constraint(equalTo: timeOfDoingTask.leadingAnchor, constant: -10),
            firstSeparator.centerYAnchor.constraint(equalTo: taskDateStackView.centerYAnchor),
            
            secondSeparator.trailingAnchor.constraint(equalTo: dayOfFinishingLabel.leadingAnchor, constant: -10),
            secondSeparator.leadingAnchor.constraint(equalTo: timeOfDoingTask.trailingAnchor, constant: 10),
            secondSeparator.centerYAnchor.constraint(equalTo: taskDateStackView.centerYAnchor),
        ])
    }
    
    func getViewSeparator() -> UIView {
        let view =  UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
}

