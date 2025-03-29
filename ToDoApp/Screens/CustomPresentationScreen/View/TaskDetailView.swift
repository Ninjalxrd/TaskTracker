//
//  TaskDetailView.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import UIKit

final class TaskDetailView: UIView {
    
    // MARK: - Callbacks
    var onDismissButtonTapped: (() -> Void)?
    var onDeleteButtonTapped: (() -> Void)?
    var onDownSwipe: (() -> Void)?
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Properties
    
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
    
    // MARK: - UI Elements
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = Sizes.blurViewCornerRadius
        return view
    }()
    
    private lazy var deleteTaskButton: UIButton = {
        let button = UIButton(primaryAction: deleteAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = Sizes.blurViewCornerRadius
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(UIColor(named: "textColor"), for: .normal)
        return button
    }()
    
    private lazy var taskTitle: UILabel = {
        let title = UILabel()
        title.font = .boldSystemFont(ofSize: 17)
        title.textColor = .label
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(primaryAction: dismissAction)
        button.setImage(UIImage(systemName: "chevron.compact.down"), for: .normal)
        button.tintColor = UIColor(named: "textColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleAndCrossButtonStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            dismissButton,
            taskTitle
        ])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constants.biggerThanBig
        return stack
    }()
    
    // MARK: Info About Begining Task
    private lazy var beginedAtTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 17)
        title.textColor = .secondaryLabel
        title.text = "Создано"
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
    
    // MARK: Info About Finishing Task
    private lazy var finishedAtTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 17)
        title.textColor = .secondaryLabel
        title.text = "Выполнено"
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
    
    // MARK: Time Stacks
    private lazy var createdAtDataStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            beginedAtTitle,
            dayOfCreatingLabel,
            timeOfCreatingLabel
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.small
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
        ])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = Constants.big
        return stack
    }()
    
    private lazy var dismissAction = UIAction { [weak self] _ in
        self?.onDismissButtonTapped?()
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private lazy var deleteAction = UIAction { [weak self] _ in
        self?.onDeleteButtonTapped?()
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    private lazy var downSwipeGestureRecognizer: UISwipeGestureRecognizer = {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(downSwipeAction))
        swipeRecognizer.direction = .down
        swipeRecognizer.delegate = self
        return swipeRecognizer
    }()
    
    // MARK: - Public Methods

    @objc func downSwipeAction() {
        self.onDownSwipe?()
    }
    
    func setupWithTask(_ task: TaskEntity) {
        self.taskTitle.text = task.title
        
        dayOfCreatingLabel.text = dayAndMonthDateFormatter.string(from: task.date ?? Date.now)
        timeOfCreatingLabel.text = timeFormatter.string(from: task.date ?? Date.now)
        
        if let finishedAt = task.finishedAt {
            dayOfFinishingLabel.text = dayAndMonthDateFormatter.string(from: finishedAt)
            timeOfFinishingLabel.text = timeFormatter.string(from: finishedAt)
            timeOfDoingTask.text = distanceCompanentsFormatter.string(from: task.date ?? Date.now,
                                                                      to: finishedAt)
        }
    }
}

private extension TaskDetailView {
    
    // MARK: - Setup UI

    func setupUI() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addGestureRecognizer(downSwipeGestureRecognizer)
        addSubview(bgView)
        bgView.addSubview(dateStackView)
        bgView.addSubview(deleteTaskButton)
        bgView.addSubview(timeOfDoingTask)
        bgView.addSubview(firstSeparator)
        bgView.addSubview(secondSeparator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: self.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: Constants.big),
            dateStackView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: Constants.big),
            dateStackView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -Constants.big),
            deleteTaskButton.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -Constants.big),
            deleteTaskButton.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: Constants.big),
            deleteTaskButton.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -Constants.big),
            
        ])
        
        NSLayoutConstraint.activate([
            timeOfDoingTask.centerXAnchor.constraint(equalTo: taskDateStackView.centerXAnchor),
            timeOfDoingTask.centerYAnchor.constraint(equalTo: taskDateStackView.centerYAnchor),
            
            firstSeparator.leadingAnchor.constraint(equalTo: createdAtDataStackView.trailingAnchor, constant: Constants.medium),
            firstSeparator.trailingAnchor.constraint(equalTo: timeOfDoingTask.leadingAnchor, constant: -Constants.medium),
            firstSeparator.centerYAnchor.constraint(equalTo: taskDateStackView.centerYAnchor),
            
            secondSeparator.trailingAnchor.constraint(equalTo: finishedAtDataStackView.leadingAnchor, constant: -Constants.medium),
            secondSeparator.leadingAnchor.constraint(equalTo: timeOfDoingTask.trailingAnchor, constant: Constants.medium),
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

// MARK: - UIGestureRecognizerDelegate

extension TaskDetailView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

