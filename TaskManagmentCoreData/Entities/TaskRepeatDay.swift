//
//  TaskRepeatDay.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 12.04.2022.
//

import Foundation

enum TaskRepeatDay: Int {
    case never = 0
    case days = 1
    case workDays = 2
    case holidays = 3
    case toWeek = 4
    case weeks = 5
    case weeks2 = 6
    case months = 7
    case months3 = 8
    case months6 = 9
    case years = 10
    
    var title: String {
        switch self {
        case .never:
            return "Никогда"
        case .days:
            return "Ежедневно"
        case .workDays:
            return "По будням"
        case .holidays:
            return "По выходным"
        case .weeks:
            return "Еженедельно"
        case .weeks2:
            return "Каждые 2 недели"
        case .months:
            return "Ежемесячно"
        case .months3:
            return "Каждые 3 месяца"
        case .months6:
            return "Каждые 6 месяцев"
        case .years:
            return "Ежегодно"
        case .toWeek:
            return "В течении 7 дней"
        }
    }
}
