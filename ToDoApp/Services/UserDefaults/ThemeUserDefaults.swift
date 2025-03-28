//
//  ThemeUserDefaults.swift
//  ToDoApp
//
//  Created by Павел on 28.03.2025.
//

import Foundation

struct ThemeUserDefaults {
    static var shared = ThemeUserDefaults()
    var theme: Theme {
        get {
            Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .dark
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}
