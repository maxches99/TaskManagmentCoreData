//
//  Date+Calendar.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 12.04.2022.
//

import Foundation


func intervalDates(from startingDate:Date, to endDate:Date, with interval:TimeInterval) -> [Date] {
    guard interval > 0 else { return [] }
    
    var dates:[Date] = [startingDate]
    var currentDate = startingDate
    
    while currentDate <= endDate {
        currentDate = currentDate.addingTimeInterval(interval)
        dates.append(currentDate)
    }
    
    return dates
}

func intervalDatesHolidays(from startingDate:Date, to endDate:Date, with interval:TimeInterval) -> [Date] {
    guard interval > 0 else { return [] }
    
    var dates:[Date] = [startingDate]
    var currentDate = startingDate
    
    while currentDate <= endDate {
        currentDate = currentDate.addingTimeInterval(interval)
        if currentDate.isDateInWeekend {
            dates.append(currentDate)
        }
    }
    
    return dates
}

func intervalDatesWorkdays(from startingDate:Date, to endDate:Date, with interval:TimeInterval) -> [Date] {
    guard interval > 0 else { return [] }
    
    var dates:[Date] = [startingDate]
    var currentDate = startingDate
    
    while currentDate <= endDate {
        currentDate = currentDate.addingTimeInterval(interval)
        if !currentDate.isDateInWeekend {
            dates.append(currentDate)
        }
    }
    
    return dates
}

func intervalDatesByMonths(from startingDate:Date, to endDate:Date, step: Int = 1) -> [Date] {
    
    var dates:[Date] = [startingDate]
    var currentDate = startingDate
    
    while currentDate <= endDate {
        currentDate = currentDate.adding(.month, value: step)
        dates.append(currentDate)
    }
    
    return dates
}

func intervalDatesByYears(from startingDate:Date, to endDate:Date, step: Int = 1) -> [Date] {
    
    var dates:[Date] = [startingDate]
    var currentDate = startingDate
    
    while currentDate <= endDate {
        currentDate = currentDate.adding(.year, value: step)
        dates.append(currentDate)
    }
    
    return dates
}

func intervalDatesByWeeks(from startingDate:Date, to endDate:Date, step: Int = 1) -> [Date] {
    
    var dates:[Date] = [startingDate]
    var currentDate = startingDate
    
    while currentDate <= endDate {
        currentDate = currentDate.adding(.weekOfMonth, value: step)
        dates.append(currentDate)
    }
    
    return dates
}

public extension Date {
    func noon(using calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    func day(using calendar: Calendar = .current) -> Int {
        calendar.component(.day, from: self)
    }
    func adding(_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: component, value: value, to: self)!
    }
    func monthSymbol(using calendar: Calendar = .current) -> String {
        calendar.monthSymbols[calendar.component(.month, from: self)-1]
    }
}

extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
}


extension Date {
    var isDateInWeekend: Bool {
        return Calendar.iso8601.isDateInWeekend(self)
    }
    var tomorrow: Date {
        return Calendar.iso8601.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.iso8601.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}
