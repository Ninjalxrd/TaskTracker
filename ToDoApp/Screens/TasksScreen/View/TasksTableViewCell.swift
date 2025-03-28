//
//  TasksTableViewCell.swift
//  ToDoApp
//
//  Created by Павел on 19.03.2025.
//

import UIKit

final class TasksTableViewCell: UITableViewCell {
    
    var onUpdateCheckmarkButton: ((_ isCompleted: Bool) -> Void)?
    var isCompleted: Bool = false {
        didSet {
            updateCheckmarkUI()
        }
    }
    var onDeleteAction: (() -> Void)?
    var onEditAction: (() -> Void)?
    var onShareAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupInteractionMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        checkmarkButton.layer.cornerRadius = checkmarkButton.frame.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isCompleted = false
        taskDateLabel.text = nil
        taskTitleLabel.text = nil
        taskDescriptionLabel.text = nil
    }

    private func updateCheckmarkUI() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            if self.isCompleted {
                self.checkmarkButton.layer.borderColor = Color.yellowCg
                self.checkmarkButton.setImage(UIImage(named: "tick"), for: .normal)
            } else {
                self.checkmarkButton.layer.borderColor = Color.grayForButtonCg
                self.checkmarkButton.setImage(UIImage(), for: .normal)
            }
        }
    }

    lazy var checkmarkButton: UIButton = {
        let button = UIButton(primaryAction: onCheckmarkTappedAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.cornerRadius = Sizes.checkmarkButtonCornerRadius
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var onCheckmarkTappedAction = UIAction { [weak self] _ in
        guard let self else { return }
        isCompleted.toggle()
        self.updateCheckmarkUI()
        self.onUpdateCheckmarkButton?(isCompleted)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private lazy var taskTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = UIColor(named: "textColor")
        label.font = .systemFont(ofSize: Sizes.taskTitleLabelSize, weight: .bold)
        return label
    }()
    
    private lazy var taskDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor(named: "textColor")
        label.font = .systemFont(ofSize: Sizes.taskDescriptionLabelSize, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var taskDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: Sizes.dateLabelSize, weight: .light)
        label.textColor = Color.lightGray
        return label
    }()
    
    private lazy var taskStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskTitleLabel, taskDescriptionLabel, taskDateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 6
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private func setupInteractionMenu() {
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    private func setupUI() {
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(taskStackView)
        
        NSLayoutConstraint.activate([
            checkmarkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            checkmarkButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            checkmarkButton.widthAnchor.constraint(equalToConstant: Sizes.checkmarkButtonWidth),
            checkmarkButton.heightAnchor.constraint(equalToConstant: Sizes.checkmarkButtonHeight),
            
            taskStackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: Constants.taskStackViewVerticalConstant),
            taskStackView.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: Constants.taskStackViewConstant),
            taskStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            taskStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.taskStackViewVerticalConstant)
        ])
    }
    
    func configureCell(with task: TaskEntity) {
        isCompleted = task.completed
        taskTitleLabel.text = task.title
        taskDateLabel.text = DateFormatterHelper.formattedRecievedDate(date: task.date ?? Date.now)
        taskDescriptionLabel.text = task.description
    }
}

extension TasksTableViewCell: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider:  { _ in
            let edit = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
                    self?.onEditAction?()
                }
            let share = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up")) {[weak self] _ in
                    self?.onShareAction?()
                }
            let delete = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive) {[weak self] _ in
                    self?.onDeleteAction?()
                }
            return UIMenu(title: "", children: [edit, share, delete])
        })
    }
}

extension TasksTableViewCell {
   static var identifier: String {
        return String(describing: self)
    }
}
