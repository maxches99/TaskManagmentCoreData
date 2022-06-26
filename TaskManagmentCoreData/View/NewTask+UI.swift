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
        Group {
            switch state {
            case .read:
                Text(taskTitle)
                .matchedGeometryEffect(id: "Title".localizationString, in: animation)
            case .write:
                TextField("Title".localizationString, text: $taskTitle, onCommit: {
                    focusedField = .description
                })
                .font(.largeTitle.bold())
                .focused($focusedField, equals: .title)
                .submitLabel(.next)
                .padding(.vertical)
                .matchedGeometryEffect(id: "Title", in: animation)
            }
        }
        .padding(.horizontal)
    }
    
    var Description: some View {
        Group {
            switch state {
            case .read:
                Text(taskDescription)
                .matchedGeometryEffect(id: "Description".localizationString, in: animation)
            case .write:
                TextField("Description".localizationString, text: $taskDescription)
                    .focused($focusedField, equals: .description)
                    .submitLabel(.next)
                    .padding(.vertical)
                .matchedGeometryEffect(id: "Description", in: animation)
            }
        }
        .padding(.horizontal)
    }
    
    var Priority: some View {
        Group {
            switch state {
            case .read:
                EmptyView()
            case .write:
                HStack {
                    Text("Priority".localizationString)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                        .opacity(0.7)
                    Spacer()
                        .frame(width: 16)
                    Picker(selection: $taskPriority, label: Text("Priority".localizationString)) {
                        Text("High".localizationString).tag(2)
                        Text("Medium".localizationString).tag(1)
                        Text("Down".localizationString).tag(0)
                            .navigationTitle("Priority".localizationString)
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical)
                .matchedGeometryEffect(id: "Priority", in: animation)
                }
            }
        }
        .padding(.horizontal)
    }
    
    var RepeatMain: some View {
        HStack {
            Text("Повтор".localizationString)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.leading)
                .opacity(0.7)
            Spacer()
//            Image(systemName: "repeat")

            Picker(selection: $taskRepeatDay, label: Text("Повтор".localizationString)) {
                ForEach(0...10, id: \.self) { i in
                    Text(TaskRepeatDay(rawValue: i)?.title.localizationString ?? "")
                        .tag(i)
                }

            }
            .pickerStyle(.automatic)
        }
        .padding(.vertical)
        .padding(.horizontal)
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
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                        .opacity(0.7)
                    Spacer()
                    switch endOfRepeat {
                    case .endless:
                        Text(endOfRepeat.title)
                    case .date:
                        Text("\(endOfRepeatData.formatted(date: .numeric, time: .omitted))")
                    }
                    
                }
            }
        }
        .padding(.horizontal)
    }
    
    var NotificationView: some View {
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
                .navigationTitle("Notification".localizationString)
                .navigationBarTitleDisplayMode(.inline)
                .interactiveDismissDisabled()
            }
            ) {
                HStack {
                    Image(systemName: "bell.badge.fill")
                    Text("Notification".localizationString)
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
                .padding(.vertical)
            }
        }
    }
    
    var DateView: some View {
        Section {
            DatePicker("", selection: $taskData)
                .datePickerStyle(.graphical)
                .labelsHidden()
        }
        .padding(.horizontal)
    }
    
}
