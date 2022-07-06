//
//  TaskCardView.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 26.06.2022.
//

import SwiftUI

struct TaskCardView: View {
    @State var task: Task
    
    @Binding var theme: ThemesType
    
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
                        .fill(task.isCompleted ? .green : theme.backgroundColor)
                        .frame(width: 15, height: 15)
                        .background(
                            Circle()
                                .stroke(theme.textColor, lineWidth:  1)
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
                            .fill(theme.textColor)
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
                                .foregroundColor(theme.textColor)
                            Text(task.taskDescription ?? "")
                                .font(.callout)
                                .foregroundColor(theme.textColor)
                        }
                        .hLeading()
                        
                        Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
                            .font(.callout)
                            .foregroundColor(theme.textColor)
                    }
                    .foregroundColor(Color(uiColor: .label))
                    
                    HStack(spacing: 12) {
                        
                        if !task.isCompleted {
                            Button {
                                task.isCompleted = true
                                
                                action
                            } label: {
                                Image(systemName: "checkmark")
                                    .foregroundColor(theme.backgroundColor)
                                    .padding(10)
                                    .background(theme.textColor, in: RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                        Text(task.isCompleted ? "Marked as Completed".localizationString : "Mark Task as Completed".localizationString)
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(!task.isCompleted ? theme.textColor : .gray)
                            .hLeading()
                    }
                }
                Spacer()
                    .frame(width: 16)
            }
            .background {
                theme.backgroundColor
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

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCardView(task: .data, theme: .constant(.eight)) {}
            .frame(width: 300)
            .frame(height: 100)
    }
}

extension Task {
    static var data: Task {
        let task = Task(context: PersistenceController.preview.container.viewContext)
        task.taskTitle = "Title"
        task.taskDescription = "Task description"
        task.priority = Int16(0)
        task.taskDate = Date()
        task.id = UUID()
        return task
    }
}
