//
//  Constants.swift
//  ToDoApp
//
//  Created by Павел on 18.03.2025.
//

import Foundation

struct Constants {
    
    // MARK: - General
    static let small: CGFloat = 5
    static let medium: CGFloat = 10
    static let big: CGFloat = 25
    static let biggerThanBig: CGFloat = 30
    
    // MARK: - TasksView
    static let tasksViewTopStackViewConstant: CGFloat = 10
    static let tasksViewTableViewConstant: CGFloat = 10

    // MARK: - TasksTableViewCell
    static let taskStackViewConstant: CGFloat = 10
    static let taskStackViewVerticalConstant: CGFloat = 5

    // MARK: - CreateEditTaskView
    static let newTaskStackViewConstant: CGFloat = 10
    
    // MARK: - SaveOverlayView
    static let saveOverlayConstant: CGFloat = 20
    
    // MARK: - ThemeTableViewCell
    static let themeTableViewCellConstant: CGFloat = 8
    
    // MARK: - SettingsView
    static let settingsViewConstant: CGFloat = 16
    static let settingsViewSmallConstant: CGFloat = 8
    
    // MARK: - ThemeTableViewCell
    static let themeButtonStackSpacing: CGFloat = 4
    static let themeButtonImageSpacing: CGFloat = 8



    
    
}

struct Sizes {
    
    // MARK: - TaskTableViewCell
    static let checkmarkButtonWidth: CGFloat = 24
    static let checkmarkButtonHeight: CGFloat = 24
    static let checkmarkButtonCornerRadius: CGFloat = checkmarkButtonWidth / 2
    static let taskTitleLabelSize: CGFloat = 16
    static let taskDescriptionLabelSize: CGFloat = 12
    static let dateLabelSize: CGFloat = 12
    
    // MARK: - TasksView
    static let tasksViewTitleLabelSize: CGFloat = 34
    static let searchBarCornerRadius: CGFloat = 10
    static let searchBarTextFieldTextSize: CGFloat = 17
    static let tableViewHeightForRow: CGFloat = 90
    static let footerHeight: CGFloat = 32
    static let footerLabelSize: CGFloat = 16

    // MARK: - CreateEditTaskView
    static let taskDateLabelSize: CGFloat = 12
    static let titleTextViewTextSize: CGFloat = 34
    static let descriptionTextViewTextSize: CGFloat = 16
    static let doneButtonTextSize: CGFloat = 17
    
    // MARK: - SaveOverlayView
    static let blurViewCornerRadius: CGFloat = 16
    static let saveOverlayTitleLabel: CGFloat = 15
    static let saveOverlayContainerWidth: CGFloat = 200
    static let saveOverlayContainerHeight: CGFloat = 80
    
    // MARK: - ToolBar
    static let toolbarHeight: CGFloat = 44
    
    // MARK: - ThemeTableViewCell
    static let containerViewCornerRadius: CGFloat = 24
    static let themeButtonCornerRadius: CGFloat = 16
    static let settingsTableViewHeight: CGFloat = 120
    static let settingsHeightForHeader: CGFloat = 44
    static let themeButtonStackHeight: CGFloat = 80
    
}
