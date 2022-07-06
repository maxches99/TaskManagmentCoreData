//
//  NewTask.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 17.01.2022.
//

import SwiftUI
import UserNotifications

struct NewTask: View {
    
    @StateObject var themesHelper: ThemesHelper = .shared
    
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
    
    @State var isAddedDate = false
    @State var isAddedTime = false
    
    @State var isPressed = false
    
    @State var countOfConditions = 0
    
    @State var imageData: Data? = nil
    
    @Environment(\.managedObjectContext) var context
    
    @State var isEditing = false
    @State var isEditingPriority = false
    
    @State var isShowingGifPicker = false
    @State var gif: String? = nil {
        didSet {
            loadData()
        }
    }
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack {
                        Title
                        
                        Description
                        
                        Priority
                        
    //                    ConditionsView
                        
                        if state == .write {
                            Section {
                                RepeatMain
                                
                                if TaskRepeatDay(rawValue: taskRepeatDay) != .never {

                                    RepeatView
                                }

                            }

                            DateView
                            
                            if isAddedDate {
                                TimeView
                            }
//                            AddGIFView
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
            .background(
                themesHelper.current.backgroundColor
            )
            
        }
        .onAppear {
            isEditing = !taskTitle.isEmpty
            
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: themesHelper.current.textUIColor]

                //Use this if NavigationBarTitle is with displayMode = .inline
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: themesHelper.current.textUIColor]
        }
    }
    
    
}

struct Previews_NewTask_Previews: PreviewProvider {
    static var previews: some View {
        
        NewTask()
            .onAppear {ThemesHelper.shared.current = .one}
        NewTask()
            .onAppear {ThemesHelper.shared.current = .two}
        NewTask()
            .onAppear {ThemesHelper.shared.current = .three}
        
        NewTask()
            .onAppear {ThemesHelper.shared.current = .four}
        NewTask()
            .onAppear {ThemesHelper.shared.current = .five}
        NewTask()
            .onAppear {ThemesHelper.shared.current = .six}
        NewTask()
            .onAppear {ThemesHelper.shared.current = .seven}
        NewTask()
            .onAppear {ThemesHelper.shared.current = .eight}
        NewTask()
            .onAppear {ThemesHelper.shared.current = .nine}
        NewTask()
            .onAppear {ThemesHelper.shared.current = .zero}
    }
}
