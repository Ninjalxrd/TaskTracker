//
//  CreateView.swift
//  ToDoApp
//
//  Created by Павел on 24.03.2025.
//

import UIKit

final class CreateView: UIView {
    
    // MARK: - Properties
    
    var onDoneButtonTapped: (() -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var taskDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: Sizes.taskDateLabelSize, weight: .medium)
        label.textColor = Color.lightGray
        return label
    }()
    
    lazy var textView: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.delegate = self
        text.backgroundColor = UIColor(named: "backgroundColor")
        addCancelButtonToKeyboard(textView: text)
        return text
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [taskDateLabel, textView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.small
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom, primaryAction: doneActionButton)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(Color.yellow, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Sizes.doneButtonTextSize, weight: .bold)
        button.isHidden = true
        return button
    }()
    
    // MARK: - Actions
    
    private lazy var cancelAction = UIAction { [weak self] _ in
        self?.endEditing(true)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private lazy var doneActionButton = UIAction {[weak self] _ in
        self?.endEditing(true)
        self?.onDoneButtonTapped?()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.newTaskStackViewConstant),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.newTaskStackViewConstant),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addCancelButtonToKeyboard(textView: UITextView) {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Sizes.toolbarHeight))
        let cancelButton = UIBarButtonItem(
            image: UIImage(systemName: "keyboard.chevron.compact.down"),
            primaryAction: cancelAction)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        toolBar.tintColor = Color.yellow
        toolBar.items = [flexibleSpace, cancelButton]
        textView.inputAccessoryView = toolBar
    }
}

// MARK: - UITextViewDelegate

extension CreateView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textView.attributedText = formattedText(from: textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        doneButton.isHidden = false
    }
    
    private func formattedText(from text: String) -> NSAttributedString {
        let lines = text.components(separatedBy: "\n")
        let attributedString = NSMutableAttributedString(string: text)
        
        if let firstLine = lines.first {
            let titleRange = (text as NSString).range(of: firstLine)
            attributedString.addAttributes([.foregroundColor: UIColor(named: "textColor") ?? .text,
                .font: UIFont.systemFont(ofSize: Sizes.titleTextViewTextSize, weight: .bold),
            ], range: titleRange)
            
            if lines.count > 1 {
                let descriptionStart = text.index(text.startIndex, offsetBy: firstLine.count + 1)
                let descriptionRange = NSRange(descriptionStart..<text.endIndex, in: text)
                attributedString.addAttributes([.foregroundColor: UIColor(named: "textColor") ?? .text,
                    .font: UIFont.systemFont(ofSize: Sizes.descriptionTextViewTextSize, weight: .medium),
                ], range: descriptionRange)
            }
        }
        return attributedString
    }
    
    func separateTitleWithDescription(from text: String) -> (title: String, description: String) {
        let lines = text.components(separatedBy: "\n")
        let title = lines.first ?? ""
        let description = lines.dropFirst().joined(separator: "\n")
        
        return (title, description)
    }
}
