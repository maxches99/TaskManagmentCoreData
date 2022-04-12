//
//  NewTask+UI.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 12.04.2022.
//

import Foundation
import SwiftUI

extension NewTask {
    
    var Title: some View {
        Section {
            TextField("Go to work".localizationString, text: $taskTitle, onCommit: {
                focusedField = .description
            })
            .focused($focusedField, equals: .title)
            .submitLabel(.next)
        } header: {
            Text("Title".localizationString)
        }
    }
    
    var Description: some View {
        Section {
            TextField("Nothing".localizationString, text: $taskDescription)
                .focused($focusedField, equals: .description)
                .submitLabel(.next)
        } header: {
            Text("Description".localizationString)
        }
    }
    
    var Priority: some View {
        Section {
            Picker(selection: $taskPriority, label: Text("Priority".localizationString)) {
                Text("High".localizationString).tag(2)
                Text("Medium".localizationString).tag(1)
                Text("Down".localizationString).tag(0)
                    .navigationTitle("Priority".localizationString)
            }
        }
    }
    
    var RepeatMain: some View {
        HStack {
            Image(systemName: "repeat")

            Picker(selection: $taskRepeatDay, label: Text("Повтор".localizationString)) {
                ForEach(0...10, id: \.self) { i in
                    Text(TaskRepeatDay(rawValue: i)?.title ?? "").tag(i)
                }
                
            }
        }
    }
    
    var RepeatView: some View {
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
    
    var DateView: some View {
        Section {
            DatePicker("", selection: $taskData)
                .datePickerStyle(.graphical)
                .labelsHidden()
        }
    }
    
}
