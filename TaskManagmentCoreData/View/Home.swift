//
//  Home.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 15.01.2022.
//

import SwiftUI
import CoreData

struct Home: View {
    
    @StateObject var themesHelper: ThemesHelper = .shared
    
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    
    @Environment(\.managedObjectContext) var context
    
    @State var isShow: Bool = false
    @State var isShowThemes: Bool = false
    
    var isEmptyTasksWithoutDate: Bool {
        let predicate: NSPredicate
        
        let filterKey = "taskDate"
        
        predicate = NSPredicate(format: "\(filterKey) == nil", argumentArray: [])
        
        var fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        fetchRequest.predicate = predicate
        
        var fetched = try? context.fetch(fetchRequest)
        
        return fetched?.count ?? 0 == 0
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    
                    CalendarView()
                    
                    TasksView()
                        .animation(.easeInOut(duration: 0.5))
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .overlay(
            Button {
                taskModel.addNewTask.toggle()
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(themesHelper.current.backgroundColor)
                    .padding()
                    .background(
                        themesHelper.current.textColor, in: Circle()
                    )
            }
                .padding()
            ,alignment: .bottomTrailing
        )
        .sheet(isPresented: $taskModel.addNewTask) {
            taskModel.editTask = nil
        } content: {
            if let taskDataModel = taskModel.editTask {
                NewTask(taskTitle: taskDataModel.taskTitle ?? "", taskDescription: taskDataModel.taskDescription ?? "", taskPriority: Int(taskDataModel.priority ?? 0))
            } else {
                NewTask(taskData: taskModel.currentDay)
                    .environmentObject(taskModel)
            }
        }
        .fullScreenCover(isPresented: $isShowThemes) {
            isShowThemes = false
        } content: {
            ThemesView()
        }
        .fullScreenCover(isPresented: $taskModel.showingOnboarding, content: {
            UIOnboardingView()
                .edgesIgnoringSafeArea(.all)
        })
        .background(themesHelper.current.backgroundColor)
    }
    
    func TasksView()->some View {
        LazyVStack(spacing: 25) {

//            if !isEmptyTasksWithoutDate {
//                HStack {
//                    Text("Без даты")
//                        .foregroundColor(.primary)
//                    Spacer()
//                    Image(systemName: "arrow.down")
//                        .foregroundColor(.primary)
//                        .rotationEffect(isShow ? .degrees(180): .degrees(360))
//                }
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 16)
//                        .foregroundColor(Color(uiColor: .secondarySystemBackground))
//                )
//                .padding(.trailing)
//                .onTapGesture {
//                    isShow.toggle()
//            }
//            }
//            if isShow {
//                DynamicFilteredView(dateToFilter: nil) { (object: Task) in
//                    TaskCardView(task: object) {
//                        try? context.save()
//                    } onDeleteAction: {
//                        context.delete(object)
//
//                        try? context.save()
//                    }
//                    .onTapGesture {
//                        taskModel.editTask = object
//                        taskModel.addNewTask.toggle()
//                    }
//                    .padding(.bottom, taskModel.isCurrentHour(date: object.taskDate ?? Date()) ? 0 : 10)
//                    .hLeading()
//                }
//                .transition(.opacity)
//            }

            
            DynamicFilteredView(dateToFilter: taskModel.currentDay) { (object: Task) in
                TaskCardView(task: object, theme: $themesHelper.current) {
                    try? context.save()
                } onDeleteAction: {
                    context.delete(object)
                    
                    try? context.save()
                }
                .onTapGesture {
                    taskModel.editTask = object
                    taskModel.addNewTask.toggle()
                }
                .padding(.bottom, taskModel.isCurrentHour(date: object.taskDate ?? Date()) ? 0 : 10)
                .hLeading()
            }
        }
        .padding(.leading)
        .padding(.top)
        .padding(.top)
        .padding(.bottom)
    }
    
    func HeaderView()->some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .center, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(themesHelper.current.textColor)
                    .animation(.easeInOut, value: 2.4)
                Text("Today".localizationString)
                    .font(.largeTitle.bold())
                    .animation(.easeInOut, value: 2.4)
                    .onTapGesture {
                        taskModel.currentDay = Date()
                    }
                    .padding(.leading)
                    .foregroundColor(themesHelper.current.textColor)
                
            }
            .hLeading()
            .onTapGesture {
                if let day = taskModel.currentWeek.first(where: {taskModel.isToday(date: $0)}) {
                    taskModel.currentDay = day
                }
            }
            Spacer()
            Button {
                isShowThemes.toggle()
            } label: {
                Image(systemName: "paintpalette")
                    .foregroundColor(themesHelper.current.textColor)
            }
        }
        .padding(.top)
        .padding(.trailing)
        .padding(.top, getSafeArea().top)
        .background(themesHelper.current.backgroundColor)
    }
    
    func CalendarView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                HStack(spacing: 10) {
                    ForEach(taskModel.currentWeek, id: \.self) { day in
                        getDayView(day: day)
                        .id(day)
                    }
                }
                .padding(.horizontal)
                .onAppear {
                    withAnimation {
                        value.scrollTo(taskModel.currentDay, anchor: .leading)
                    }
                    
                }
            }
        }
    }
    
    func getDayView(day: Date) -> some View {
        VStack(spacing: 10) {
            Text(taskModel.extractDate(date: day, format: "dd"))
                .font(.system(size: 15))
                .fontWeight(.semibold)
                .foregroundColor(taskModel.isToday(date: day) ? themesHelper.current.backgroundColor : themesHelper.current.textColor)
            
            Text(taskModel.extractDate(date: day, format: "EEE"))
                .font(.system(size: 14))
                .foregroundColor(taskModel.isToday(date: day) ? themesHelper.current.backgroundColor : themesHelper.current.textColor)
            
            Circle()
                .fill(themesHelper.current.backgroundColor)
                .frame(width: 8, height: 8)
                .opacity(taskModel.isToday(date: day) ? 1 : 0)
        }
        .foregroundColor(taskModel.isToday(date: day) ? Color(uiColor: .systemBackground) : Color(uiColor: .label))
        .frame(width: 45, height: 90)
        .background(
            ZStack {
                if taskModel.isToday(date: day) {
                    Capsule()
                        .fill(themesHelper.current.textColor)
                        .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                }
            }
        )
        .contentShape(Capsule())
        .onTapGesture {
            withAnimation {
                taskModel.currentDay = day
            }
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    
    static var persistenceController = PersistenceController.preview
    
    static var previews: some View {
        
        Home()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        Home()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .preferredColorScheme(.dark)
    }
}
