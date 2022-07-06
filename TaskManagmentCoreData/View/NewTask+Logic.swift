//
//  NewTask+Logic.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 12.04.2022.
//

import Foundation
import UserNotifications
import FirebaseAnalytics

extension NewTask {
    
    func saveAction() {
        let typeOfRepeat = TaskRepeatDay(rawValue: taskRepeatDay)
        
        switch endOfRepeat {
        case .endless:
            endOfRepeatData = Date.init(timeInterval: 4111073428, since: taskData)
        case .date:
            break
        }
        
        let startingDate = taskData
        let endDate = endOfRepeatData
        let intervalBetweenDates:TimeInterval = 3600 * 24// three hours
        
        switch typeOfRepeat {
        case .never:
            saveTask(date: taskData)
        case .days:
            
            let dates:[Date] = intervalDates(from: startingDate, to: endDate, with: intervalBetweenDates)
            dates.forEach { data in
                saveTask(date: data)
            }
        case .workDays:
            
            let dates:[Date] = intervalDatesWorkdays(from: startingDate, to: endDate, with: intervalBetweenDates)
            dates.forEach { data in
                saveTask(date: data)
            }
        case .holidays:
            
            let dates:[Date] = intervalDatesHolidays(from: startingDate, to: endDate, with: intervalBetweenDates)
            dates.forEach { data in
                saveTask(date: data)
            }
        case .toWeek:
            let startingDate = taskData
            let endDate = Date(timeInterval: 604800, since: taskData)
            let intervalBetweenDates:TimeInterval = 3600 * 24// three hours
            
            let dates:[Date] = intervalDates(from: startingDate, to: endDate, with: intervalBetweenDates)
            dates.forEach { data in
                saveTask(date: data)
            }
        case .weeks:
            
            
            let dates:[Date] = intervalDatesByWeeks(from: startingDate, to: endDate)
            dates.forEach { data in
                saveTask(date: data)
            }
        case .weeks2:
            
            
            let dates:[Date] = intervalDatesByWeeks(from: startingDate, to: endDate, step: 2)
            dates.forEach { data in
                saveTask(date: data)
            }
        case .months:
            
            
            let dates:[Date] = intervalDatesByMonths(from: startingDate, to: endDate)
            dates.forEach { data in
                saveTask(date: data)
            }
        case .months3:
            
            
            let dates:[Date] = intervalDatesByMonths(from: startingDate, to: endDate, step: 3)
            dates.forEach { data in
                saveTask(date: data)
            }
        case .months6:
            
            
            let dates:[Date] = intervalDatesByMonths(from: startingDate, to: endDate, step: 6)
            dates.forEach { data in
                saveTask(date: data)
            }
        case .years:
            
            
            let dates:[Date] = intervalDatesByYears(from: startingDate, to: endDate)
            dates.forEach { data in
                saveTask(date: data)
            }
        default:
            break
        }
        
        
        
        dismiss()
    }
    
    func scheduleNotification(_ date: Date) {
        
        let content = UNMutableNotificationContent()
        
        content.title = taskTitle
        content.body = taskDescription
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let identifier = "chesnikov.taskmanager.local"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func saveTask(date: Date) {
        let task = Task(context: context)
        task.taskTitle = taskTitle
        task.taskDescription = taskDescription
        task.priority = Int16(taskPriority)
        if !isEditing {
            task.taskDate = date
            task.id = task.id ?? id
        }
        
        scheduleNotification(date)
        
        try? context.save()
        
        AnalyticsHelper.shared.log(.TaskSaved(task))
    }
    
}
