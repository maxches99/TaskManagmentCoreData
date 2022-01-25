//
//  NewTask.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 17.01.2022.
//

import SwiftUI

struct NewTask: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @State var taskData: Date = Date()
    
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var taskModel: TaskViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Go to work", text: $taskTitle)
                } header: {
                    Text("Task Title")
                }
                
                Section {
                    TextField("Nothing", text: $taskDescription)
                } header: {
                    Text("Task Description")
                }
                
                if taskModel.editTask == nil {
                    Section {
                        DatePicker("", selection: $taskData)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                    } header: {
                        Text("Task Title")
                }
                } else {
                    
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let task = taskModel.editTask {
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                        } else {
                            let task = Task(context: context)
                            task.taskTitle = taskTitle
                            task.taskDescription = taskDescription
                            task.taskDate = taskData
                        }
                        
                        
                        try? context.save()
                        
                        dismiss()
                    }
                    .disabled(taskTitle.isEmpty || taskDescription.isEmpty)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            
        }
        .onAppear {
            if let task = taskModel.editTask {
                taskTitle = task.taskTitle ?? ""
                taskDescription = task.taskDescription ?? ""
            }
        }
    }
}

struct Previews_NewTask_Previews: PreviewProvider {
    static var previews: some View {
        NewTask()
    }
}
