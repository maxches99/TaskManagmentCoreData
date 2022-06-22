//
//  Home.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 15.01.2022.
//

import SwiftUI

struct Home: View {
    
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.editMode) var editButtonContext
    
    @State var isShow: Bool = true
    
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
                    .foregroundColor(Color(uiColor: .systemBackground))
                    .padding()
                    .background(
                        Color(uiColor: .label), in: Circle()
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
        .fullScreenCover(isPresented: $taskModel.showingOnboarding, content: {
            UIOnboardingView()
                .edgesIgnoringSafeArea(.all)
        })
    }
    
    func TasksView()->some View {
        LazyVStack(spacing: 25) {
            DynamicFilteredView(dateToFilter: taskModel.currentDay) { (object: Task) in
                TaskCardView(task: object)
            }
        }
        .padding()
        .padding(.top)
    }
    
    func TaskCardView(task: Task)->some View {
        HStack(alignment: editButtonContext?.wrappedValue == .active ? .center : .top, spacing: 30) {
            
            
            if editButtonContext?.wrappedValue == .active {
                VStack(spacing: 10) {
                    
                    if task.taskDate?.compare(Date()) == .orderedAscending || Calendar.current.isDateInToday(task.taskDate ?? Date()) {
                        Button {
                            taskModel.editTask = task
                            taskModel.addNewTask.toggle()
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title2)
                                .foregroundColor(.primary)
                            
                        }
                    }
                    
                    Button {
                        context.delete(task)
                        
                        try? context.save()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                        
                    }
                }
            } else {
                VStack(spacing: 10) {
                    Circle()
                        .fill(task.isCompleted ? .green : Color(uiColor: .systemBackground))
                        .frame(width: 15, height: 15)
                        .background(
                            Circle()
                                .stroke(Color(uiColor: .label), lineWidth:  1)
                                .padding(-3)
                        )
                        .scaleEffect(!taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0.8 : 1)
                        .onTapGesture {
                            task.isCompleted = false
                            
                            try? context.save()
                        }
                    switch task.priority {
                    case 1:
                        Rectangle()
                            .fill(Color(uiColor: .orange))
                            .frame(width: 4)
                            .cornerRadius(2)
                    case 2:
                        Rectangle()
                            .fill(Color(uiColor: .red))
                            .frame(width: 4)
                            .cornerRadius(2)
                    default:
                        Rectangle()
                            .fill(Color(uiColor: .label))
                            .frame(width: 4)
                            .cornerRadius(2)
                    }
                }
            }
            
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                        
                        Text(task.taskDescription ?? "")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    
                    Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
                        .font(.callout)
                }
                .foregroundColor(Color(uiColor: .label))
                
                HStack(spacing: 12) {
                    
                    if !task.isCompleted {
                        Button {
                            task.isCompleted = true
                            
                            try? context.save()
                        } label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(uiColor: .systemBackground))
                                .padding(10)
                                .background(Color(uiColor: .label), in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    
                    Text(task.isCompleted ? "Marked as Completed".localizationString : "Mark Task as Completed".localizationString)
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(!task.isCompleted ? Color(uiColor: .label) : .gray)
                        .hLeading()
                }
            }
            .foregroundColor(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? Color(uiColor: .label) : Color(uiColor: .systemBackground))
            .padding(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 15 : 0)
            .padding(.bottom, taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0 : 10)
            .hLeading()
            .background(
                Color(uiColor: .systemBackground)
                    .cornerRadius(25)
                    .opacity(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0)
            )
        }
        .hLeading()
    }
    
    func HeaderView()->some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .center, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                    .animation(.easeInOut, value: 2.4)
                Text("Today".localizationString)
                    .font(.largeTitle.bold())
                    .animation(.easeInOut, value: 2.4)
                    .onTapGesture {
                        taskModel.currentDay = Date()
                    }
                    .padding(.leading)
                
            }
            .hLeading()
            .onTapGesture {
                if let day = taskModel.currentWeek.first(where: {taskModel.isToday(date: $0)}) {
                    taskModel.currentDay = day
                }
            }
            
            EditButton()
                .foregroundColor(Color(uiColor: .label))
        }
        .padding(.top)
        .padding(.trailing)
        .padding(.top, getSafeArea().top)
        .background(Color(uiColor: .systemBackground))
    }
    
    func CalendarView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(taskModel.currentWeek, id: \.self) { day in
                    VStack(spacing: 10) {
                        Text(taskModel.extractDate(date: day, format: "dd"))
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                        
                        Text(taskModel.extractDate(date: day, format: "EEE"))
                            .font(.system(size: 14))
                        
                        Circle()
                            .fill(Color(uiColor: .systemBackground))
                            .frame(width: 8, height: 8)
                            .opacity(taskModel.isToday(date: day) ? 1 : 0)
                    }
                    .foregroundColor(taskModel.isToday(date: day) ? Color(uiColor: .systemBackground) : Color(uiColor: .label))
                    .frame(width: 45, height: 90)
                    .background(
                        ZStack {
                            if taskModel.isToday(date: day) {
                                Capsule()
                                    .fill(Color(uiColor: .label))
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
            .padding(.horizontal)
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
