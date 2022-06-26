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
    
    @State var isShow: Bool = true
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    
                    CalendarView()
                    //                    Text("aa")
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
                TaskCardView(task: object) {
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
    
    struct TaskCardView: View {
        @State var task: Task
        
        @State var action: () -> Void
        
        @State public var onDeleteState: Bool = false
        
        public var onDeleteAction: (() -> Void)?
        
        @State public var offset = CGSize.zero
        
        var DeleteButtonContent: some View {
            ZStack {
                Rectangle()
                    .fill(Color.red)
                HStack {
                    Spacer()
                    VStack(spacing: 0) {
                        Spacer()
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 21, height: 22, alignment: .center)
                            .foregroundColor(.white)
                            .accentColor(.white)
                        Spacer()
                    }
                    Spacer()
                        .frame(width: 15)
                }
            }
        }
        
        
        var body: some View {
            ZStack {
                if offset != .zero {
                    Button(action: {
                        onDeleteAction!()
                        offset = .zero
                        onDeleteState = false
                    }) {
                        DeleteButtonContent
                    }
                    .transition(.asymmetric(insertion: .identity, removal: .slide))
                }
                HStack {
                    VStack(spacing: 10) {
                        Circle()
                            .fill(task.isCompleted ? .green : Color(uiColor: .systemBackground))
                            .frame(width: 15, height: 15)
                            .background(
                                Circle()
                                    .stroke(Color(uiColor: .label), lineWidth:  1)
                                    .padding(-3)
                            )
                            .onTapGesture {
                                task.isCompleted = false
                                
                                //                            try? context.save()
                                action
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
                    
                    Spacer()
                        .frame(width: 30)
                    
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
                                    
                                    action
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
                    Spacer()
                        .frame(width: 16)
                }
                .background {
                    Rectangle()
                        .foregroundColor(Color(uiColor: .systemBackground))
                }
                .offset(self.offset)
                //                .animation(.spring())
                .gesture(
                    DragGesture(minimumDistance: 50, coordinateSpace: .named("Custom"))
                        .onChanged { gesture in
                            if gesture.translation.height > 0 || gesture.translation.height < 0 {
                                self.offset.height = 0
                            }
                            self.offset.width = gesture.translation.width < -60 ? gesture.translation.width : 0
                            if gesture.translation.width < 0 {
                                onDeleteState = true
                            }
                            
                        }
                        .onEnded { _ in
                            if self.offset.width < -130 {
                                onDeleteAction!()
                            }
                            if self.offset.width < -50 {
                                self.offset.width = -60
                            } else {
                                withAnimation {
                                    self.offset = .zero
                                    self.onDeleteState = false
                                }
                            }
                            
                        }
                )
            }
        }
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
