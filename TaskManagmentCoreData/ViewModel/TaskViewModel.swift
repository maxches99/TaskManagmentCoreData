//
//  TaskViewModel.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 15.01.2022.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    
    @Published var currentWeek: [Date] = []
    
    @Published var currentDay: Date = Date()

    
    @Published var filteredTasks: [Task]?
    
    @Published var addNewTask: Bool = false
    
    @Published var editTask: Task?
    
    @Published var showingOnboarding: Bool = false
    
    @Published var tasks: [Task] = []
    
    var context: NSManagedObjectContext
    
    init() {
        
        self.context = PersistenceController.shared.container.viewContext
        
        if !UserDefaults.standard.bool(forKey: "isOpened") {
            UserDefaults.standard.set(true, forKey: "isOpened")
            showingOnboarding = true
        }
        fetchCurrentWeek()
        
//        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
//        do {
//            let fetchedEmployees = try context.fetch(employeesFetch) as! [Task]
//            tasks = fetchedEmployees
//            fetchedEmployees.forEach {
//                if $0.fromCalendar {
//                    context.delete($0)
//                }
//            }
//        } catch {
//            fatalError("Failed to fetch employees: \(error)")
//        }
        
    }
    
    func fetchCurrentWeek() {
        
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else { return }
        
        (0...31).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
            
        }
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        let isToday = calendar.isDateInToday(date)
        
        return (hour == currentHour && isToday)
    }
}
