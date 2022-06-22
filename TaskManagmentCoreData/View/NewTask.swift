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
    
    enum StateOfScreen {
        case read
        case write
    }
    
    @Environment(\.dismiss) var dismiss
    
    @State var state: StateOfScreen = .write
    
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
    @State var isEditingPriority = false
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    Title
                    
                    Description
                    
                    Priority
                    
//                    NotificationView
                    
                    if state == .write {
                        Section {
                            RepeatMain
                            if TaskRepeatDay(rawValue: taskRepeatDay) != .never {
                                RepeatView
                            }
                            
                        }
                        
                        DateView
                    }
                }
                .listStyle(.insetGrouped)
                
                .navigationTitle(isEditing ? "Change Task".localizationString : "Add New Task".localizationString)
                .navigationBarTitleDisplayMode(.inline)
                .interactiveDismissDisabled()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(state == .write ? "Save".localizationString : "Edit".localizationString) {
                            if state == .write {
                                saveAction()
                            } else {
                                state = .write
                            }
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
            
        }
        .onAppear {
            isEditing = !taskTitle.isEmpty
            
            
        }
    }
    
    
}

struct Previews_NewTask_Previews: PreviewProvider {
    static var previews: some View {
        NewTask()
        NewTask()
            .colorScheme(.dark)
        NewTask(taskTitle: "task", taskDescription: "", taskPriority: 2)
            .colorScheme(.dark)
    }
}
