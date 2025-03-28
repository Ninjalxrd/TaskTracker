//
//  Color.swift
//  ToDoApp
//
//  Created by Павел on 18.03.2025.
//

import Foundation
import UIKit

final class Color {
    static let white = UIColor(hex: "F4F4F4")
    static let lightGray = UIColor(hex: "67686D")
    static let darkerThanLightButLighterThanDark = UIColor(hex: "3A3F47")
    static let yellow = UIColor(hex: "FED702")
    static let gray = UIColor(hex: "272729")
    static let grayCg = UIColor(red: 39/255, green: 39/255, blue: 41/255, alpha: 1).cgColor
    static let grayForButtonCg = UIColor(red: 77/255, green: 85/255, blue: 94/255, alpha: 1).cgColor
    static let yellowCg = UIColor(red: 254/255, green: 215/255, blue: 2/255, alpha: 1).cgColor
    
}

extension UIColor {

    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        let length = hexSanitized.count
        
        guard length == 6 || length == 8 else { return nil }
        
        var rgbValue: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgbValue) else { return nil }
        
        if length == 6 {
            let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(rgbValue & 0x0000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: alpha)
        } else {
            let r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            let g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            let b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            let a = CGFloat(rgbValue & 0x000000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: a)
        }
    }
}
