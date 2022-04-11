//
//  NewTask.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 17.01.2022.
//

import SwiftUI
import UserNotifications

struct NewTask: View {
    
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    @Namespace var animation
    
    enum Field: Hashable {
        case title
        case description
    }
    
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
    
    enum TypeEndOfRepeat: Int {
        case endless = 0
        case date = 1
        
        var title: String {
            switch self {
            case .endless:
                return "Никогда"
            case .date:
                return "Дата окончания"
            }
        }
    }
    
    @Environment(\.dismiss) var dismiss
    
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @State var taskData: Date = Date()
    @State var taskPriority: Int = 0
    @State var id = UUID()
    
    @State var taskRepeatDay: Int = 0
    @State var endOfRepeat: TypeEndOfRepeat = .endless
    @State var endOfRepeatData: Date = Date()
    
    @Environment(\.managedObjectContext) var context
    
    @State var isEditing = false
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Go to work".localizationString, text: $taskTitle, onCommit: {
                        focusedField = .description
                    })
                    .focused($focusedField, equals: .title)
                    .submitLabel(.next)
                } header: {
                    Text("Title".localizationString)
                }
                
                Section {
                    TextField("Nothing".localizationString, text: $taskDescription)
                        .focused($focusedField, equals: .description)
                        .submitLabel(.next)
                } header: {
                    Text("Description".localizationString)
                }
                
                Section {
                    Picker(selection: $taskPriority, label: Text("Priority".localizationString)) {
                        Text("High".localizationString).tag(2)
                        Text("Medium".localizationString).tag(1)
                        Text("Down".localizationString).tag(0)
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Priority".localizationString)
                }
                
                if !isEditing {
                    Section {
                        HStack {
                            Image(systemName: "repeat")
                            Picker(selection: $taskRepeatDay, label: Text("Повтор".localizationString)) {
                                ForEach(0...10, id: \.self) { i in
                                    Text(TaskRepeatDay(rawValue: i)?.title ?? "").tag(i)
                                }
                                
                            }
                        }
                        if TaskRepeatDay(rawValue: taskRepeatDay) != .never {
                            HStack {
                                NavigationLink(destination: {
                                    NavigationView {
                                        List {
                                            Section {
                                                ForEach(0...1, id: \.self) { i in
                                                    Button {
                                                        endOfRepeat = TypeEndOfRepeat(rawValue: i) ?? .endless
                                                    } label: {
                                                        HStack {
                                                            Text(TypeEndOfRepeat(rawValue: i)?.title ?? "")
                                                                .foregroundColor(Color(uiColor: .label))
                                                            Spacer()
                                                            if TypeEndOfRepeat(rawValue: i) == endOfRepeat {
                                                                Image(systemName: "checkmark")
                                                                    .foregroundColor(.blue)
                                                                    .animation(.linear)
                                                            }
                                                            
                                                        }
                                                    }
                                                }
                                                switch endOfRepeat {
                                                case .date:
                                                    DatePicker("", selection: $endOfRepeatData, in: taskData...)
                                                        .datePickerStyle(.graphical)
                                                        .labelsHidden()
                                                        .transition(.move(edge: .top))
                                                        .animation(.easeInOut(duration: 1))
                                                default:
                                                    EmptyView()
                                                }
                                            }
                                        }
                                        
                                    }
                                    .navigationTitle("Конец повтора".localizationString)
                                    .navigationBarTitleDisplayMode(.inline)
                                    .interactiveDismissDisabled()
                                }
                                ) {
                                    HStack {
                                        Text("Конец повтора".localizationString)
                                        Spacer()
                                        switch endOfRepeat {
                                        case .endless:
                                            Text(endOfRepeat.title)
                                                .foregroundColor(.gray)
                                        case .date:
                                            Text("\(endOfRepeatData.formatted(date: .numeric, time: .omitted))")
                                                .foregroundColor(.gray)
                                        }
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    Section {
                        DatePicker("", selection: $taskData)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                    } header: {
                        Text("Date".localizationString)
                    }
                } else {
                    
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add New Task".localizationString)
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save".localizationString) {
                        
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
                    .disabled(taskTitle.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel".localizationString) {
                        dismiss()
                    }
                }
            }
            
        }
        .onAppear {
            isEditing = !taskTitle.isEmpty
            
            notificationCenter.requestAuthorization(options: options) {
                (didAllow, error) in
                if !didAllow {
                    print("User has declined notifications")
                }
            }
        }
    }
    
    func scheduleNotification(_ date: Date) {
        
        let content = UNMutableNotificationContent() // Содержимое уведомления
        
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
        if !isEditing {
            task.taskDate = date
            task.priority = Int16(taskPriority)
            task.id = task.id ?? id
        }
        
        scheduleNotification(date)
        
        try? context.save()
    }
}

struct Previews_NewTask_Previews: PreviewProvider {
    static var previews: some View {
        NewTask()
    }
}

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
