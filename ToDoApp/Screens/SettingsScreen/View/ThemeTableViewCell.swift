//
//  ThemeTableViewCell.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import UIKit

final class ThemeTableViewCell: UITableViewCell {
    
    var setSystemTheme: (() -> Void)?
    var setLightTheme: (() -> Void)?
    var setDarkTheme: (() -> Void)?
    
    private var selectedTheme: UIButton?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "containerColor")
        view.layer.cornerRadius = Sizes.containerViewCornerRadius
        return view
    }()
    
    private lazy var systemAction = UIAction { [weak self] _ in
        guard let self else { return }
        self.setSystemTheme?()
        self.updateSelection(self.systemThemeButton)
    }
    private lazy var lightAction = UIAction { [weak self] _ in
        guard let self else { return }
        self.setLightTheme?()
        self.updateSelection(self.lightThemeButton)
    }
    private lazy var darkAction = UIAction { [weak self] _ in
        guard let self else { return }
        self.setDarkTheme?()
        self.updateSelection(self.darkThemeButton)
    }

    private func createThemeButton(title: String, subtitle: String?, image: UIImage?, action: UIAction) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(named: "buttonColor")
        config.baseForegroundColor = UIColor(named: "textColor")
        config.cornerStyle = .large
        config.title = title
        config.subtitle = subtitle
        config.image = image
        config.imagePlacement = .top
        config.imagePadding = 8
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(action, for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }
    
    private lazy var systemThemeButton: UIButton = createThemeButton(
        title: "Системная",
        subtitle: "Такая же, как\nна устройстве",
        image: nil,
        action: systemAction)

    private lazy var lightThemeButton: UIButton = createThemeButton(
        title: "Светлая",
        subtitle: nil,
        image: UIImage(systemName: "sun.max"),
        action: lightAction)
    
    private lazy var darkThemeButton: UIButton = createThemeButton(
        title: "Тёмная",
        subtitle: nil,
        image: UIImage(systemName: "moon.stars"),
        action: darkAction)
    
    private lazy var themeButtonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [systemThemeButton, lightThemeButton, darkThemeButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    private func applySavedTheme() {
        let savedTheme = ThemeUserDefaults.shared.theme.getUserInterfaceStyle()
        switch savedTheme {
        case .unspecified:
            updateSelection(systemThemeButton)
        case .light:
            updateSelection(lightThemeButton)
        case .dark:
            updateSelection(darkThemeButton)
        @unknown default:
            updateSelection(darkThemeButton)
        }
    }
    
    private func setupUI() {
        
        contentView.addSubview(containerView)
        setupButtons()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor , constant: Constants.themeTableViewCellConstant),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.themeTableViewCellConstant),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.themeTableViewCellConstant),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.themeTableViewCellConstant)
        ])
        applySavedTheme()
    }
    
    private func setupButtons() {
        containerView.addSubview(themeButtonsStack)
        
        NSLayoutConstraint.activate([
            themeButtonsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.themeTableViewCellConstant),
            themeButtonsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.themeTableViewCellConstant),
            themeButtonsStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            themeButtonsStack.heightAnchor.constraint(equalToConstant: Sizes.themeButtonStackHeight)
        ])
    }
    
    private func updateSelection(_ selectedButton: UIButton) {
        selectedTheme?.layer.borderWidth = 0
        selectedButton.layer.borderWidth = 2
        selectedButton.layer.borderColor = Color.yellowCg
        selectedButton.clipsToBounds = true
        selectedButton.layer.cornerRadius = Sizes.themeButtonCornerRadius
        selectedTheme = selectedButton
    }
}

extension ThemeTableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
