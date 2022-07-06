//
//  ThemesHelper.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 05.07.2022.
//

import SwiftUI
import UIKit

class ThemesHelper: ObservableObject {
    
    static var shared: ThemesHelper = ThemesHelper()
    
    @Published var current: ThemesType = .one
    
    
}

enum ThemesType: String, CaseIterable {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "10"
    
    var title: String {
        switch self {
        case .zero:
            return "classic"
        case .one:
            return "one"
        case .two:
            return "two"
        case .three:
            return "three"
        case .four:
            return "four"
        case .five:
            return "five"
        case .six:
            return "six"
        case .seven:
            return "seven"
        case .eight:
            return "eight"
        case .nine:
            return "nine"
        case .ten:
            return "ten"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .zero:
            return Color(uiColor: .systemBackground)
        default:
            return Color(self.rawValue)
        }
    }
    
    var textColor: Color {
        switch self {
        case .zero:
            return Color(uiColor: .label)
        default:
            return Color(self.rawValue + "text")
        }
    }
    
    var interactiveColor: Color {
        switch self {
        default:
            return Color(self.rawValue + "interactive")
        }
    }
    
    var backgroundUIColor: UIColor {
        switch self {
        case .zero:
            return .systemBackground
        default:
            return UIColor(named: self.rawValue)!
        }
    }
    
    var textUIColor: UIColor {
        switch self {
        case .zero:
            return .label
        default:
            return UIColor(named: self.rawValue + "text")!
        }
    }
    
    var interactiveUIColor: UIColor {
        switch self {
        default:
            return UIColor(named: self.rawValue + "interactive")!
        }
    }
}

