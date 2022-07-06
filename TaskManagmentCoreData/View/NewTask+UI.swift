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
        TextField("".localizationString, text: $taskTitle, onCommit: {
            focusedField = .description
        })
        .font(.largeTitle.bold())
        .focused($focusedField, equals: .title)
        .submitLabel(.next)
        .placeholder(when: taskTitle.isEmpty) {
            Text("Title".localizationString)
                .font(.largeTitle.bold())
                .foregroundColor(themesHelper.current.textColor.opacity(0.5))
        }
        .foregroundColor(themesHelper.current.textColor)
        .padding(.vertical)
        .matchedGeometryEffect(id: "Title", in: animation)
        .padding(.horizontal)
    }
    
    var Description: some View {
        TextField("".localizationString, text: $taskDescription)
            .focused($focusedField, equals: .description)
            .submitLabel(.next)
            .placeholder(when: taskDescription.isEmpty) {
                Text("Description".localizationString)
                    .foregroundColor(themesHelper.current.textColor.opacity(0.5))
            }
            .foregroundColor(themesHelper.current.textColor)
            .padding(.vertical)
            .matchedGeometryEffect(id: "Description", in: animation)
        .padding(.horizontal)
    }
    
    var Priority: some View {
        HStack {
            Text("Priority".localizationString)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(themesHelper.current.textColor)
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
        .padding(.horizontal)
    }
    
    var RepeatMain: some View {
        HStack {
            Text("Повтор".localizationString)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(themesHelper.current.textColor)
                .multilineTextAlignment(.leading)
                .opacity(0.7)
            Spacer()
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
                            ForEach(0...1, id: \.self) { i in
                                Button {
                                    endOfRepeat = TypeEndOfRepeat(rawValue: i) ?? .endless
                                } label: {
                                    HStack {
                                        switch themesHelper.current {
                                        case .one, .two, .six, .eight, .ten:
                                            Text(TypeEndOfRepeat(rawValue: i)?.title ?? "")
                                                .colorInvert()
                                                .foregroundColor(themesHelper.current.textColor)
                                            Spacer()
                                            if TypeEndOfRepeat(rawValue: i) == endOfRepeat {
                                                Image(systemName: "checkmark")
                                                    .colorInvert()
                                                    .foregroundColor(themesHelper.current.textColor)
                                                    .animation(.linear)
                                            }
                                        default:
                                            Text(TypeEndOfRepeat(rawValue: i)?.title ?? "")
                                                .foregroundColor(themesHelper.current.textColor)
                                            Spacer()
                                            if TypeEndOfRepeat(rawValue: i) == endOfRepeat {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(themesHelper.current.textColor)
                                                    .animation(.linear)
                                            }
                                        }
                                        
                                        
                                    }
                                }
                            }
                            switch endOfRepeat {
                            case .date:
//                                DatePicker("", selection: $endOfRepeatData, in: taskData...)
//                                    .datePickerStyle(.graphical)
//                                    .labelsHidden()
//                                    .colorInvert()
//                                    .colorMultiply(themesHelper.current.textColor)
//                                    .accentColor(themesHelper.current.backgroundColor)
//                                    .transition(.move(edge: .top))
//                                    .animation(.easeInOut(duration: 1))
                                switch themesHelper.current {
                                case .one, .two, .six, .eight, .ten:
                                    DatePicker("", selection: $endOfRepeatData)
                                        .datePickerStyle(.graphical)
                                        .labelsHidden()
                                    
                                        .colorInvert()
                                        .colorMultiply(themesHelper.current.textColor)
                                        .accentColor(themesHelper.current.backgroundColor)
                                        .transition(.scale)
                                case .nine:
                                    DatePicker("", selection: $endOfRepeatData)
                                        .datePickerStyle(.graphical)
                                        .labelsHidden()
                                    
                                        .colorInvert()
                                        .colorMultiply(themesHelper.current.backgroundColor)
                                        .accentColor(themesHelper.current.textColor)
                                        .colorInvert()
                                        .transition(.scale)
                                case .zero:
                                    DatePicker("", selection: $endOfRepeatData)
                                        .datePickerStyle(.graphical)
                                        .labelsHidden()
                                        .transition(.scale)
                                default:
                                    DatePicker("", selection: $endOfRepeatData)
                                        .datePickerStyle(.graphical)
                                        .labelsHidden()
                                        .accentColor(themesHelper.current.textColor)
                                        .transition(.scale)
                                }
                            default:
                                EmptyView()
                            }
                        }
                        .colorMultiply(themesHelper.current != .zero  ? themesHelper.current.backgroundColor : .white)
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
                        .foregroundColor(themesHelper.current.textColor)
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
    
    var ConditionsView: some View {
        HStack {
            Image(systemName: "plus")
                .font(.caption)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.leading)
                .opacity(0.7)
            Text("Add action condition".localizationString)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.leading)
                .opacity(0.7)
            Spacer()
            
        }
        .padding()
    }
    
    var DateView: some View {
        Section {
            switch themesHelper.current {
            case .one, .two, .six, .eight, .ten:
                DatePicker("", selection: $taskData)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                
                    .colorInvert()
                    .colorMultiply(themesHelper.current.textColor)
                    .accentColor(themesHelper.current.backgroundColor)
                    .transition(.scale)
            case .nine:
                DatePicker("", selection: $taskData)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                
                    .colorInvert()
                    .colorMultiply(themesHelper.current.backgroundColor)
                    .accentColor(themesHelper.current.textColor)
                    .colorInvert()
                    .transition(.scale)
            case .zero:
                DatePicker("", selection: $taskData)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .transition(.scale)
            default:
                DatePicker("", selection: $taskData)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .accentColor(themesHelper.current.textColor)
                    .transition(.scale)
            }
            //            }
        }
        .padding(.horizontal)
    }
    
    var TimeView: some View {
        Section {
            HStack {
                Text("Time")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                    .opacity(0.7)
                Spacer()
                Toggle(isOn: $isAddedTime, label: { })
            }
            if isAddedTime {
                DatePicker("", selection: $taskData, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .transition(.scale)
            }
        }
        .padding(.horizontal)
    }
    
    var AddGIFView: some View {
        Section {
            HStack {
                Text("Add GIF")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                    .opacity(0.7)
                Spacer()
                Text(gif ?? "")
            }
            .onTapGesture {
                isShowingGifPicker.toggle()
            }
            
            if let data = imageData {
                GIFImage(data: data)
                    .frame(height: 300)
            }
        }
        .padding(.horizontal)
    }
    
    func loadData() {
        let task = URLSession.shared.dataTask(with: URL(string: "https://media1.giphy.com/media/TjAcxImn74uoDYVxFl/giphy.gif?cid=eae969cd0ku3wojny7vgw3yip2lklpq03q28llw4q004sqy4&rid=giphy.gif&ct=g")!) { data, response, error in
            imageData = data
        }
        task.resume()
    }
    
}

extension View {
    @ViewBuilder func changeTextColor(_ color: Color) -> some View {
        if UITraitCollection.current.userInterfaceStyle == .light {
            self.colorInvert().colorMultiply(color)
        } else {
            self.colorMultiply(color)
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
