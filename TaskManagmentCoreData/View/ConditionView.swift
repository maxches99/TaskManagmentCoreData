//
//  ConditionView.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 26.06.2022.
//

import SwiftUI

enum ConditionType {
    case New
    case Date
    case Repeat
    case Priority
}

struct ConditionView: View {
    
    @State var type: ConditionType = .New
    
    var body: some View {
        HStack {
            switch type {
            case .New:
                Circle()
                    .frame(width: 10)
                    .foregroundColor(Color.gray)
                    .opacity(0.7)
                Text("New condition")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                    .opacity(0.7)
                Spacer()
                Image(systemName: "plus.square.fill.on.square.fill")
                    .font(.callout)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                    .opacity(0.7)
            case .Date:
                Circle()
                    .frame(width: 10)
                    .foregroundColor(Color.gray)
                    .opacity(0.7)
                Text("Date")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                    .opacity(0.7)
                Spacer()
                Image(systemName: "calendar")
                    .font(.callout)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.leading)
                    .opacity(0.7)
            case .Repeat:
                EmptyView()
            case .Priority:
                EmptyView()
            }
            
            Picker(selection: $type, label: Image(systemName: "plus.square.fill.on.square.fill")) {
                Text("New").tag(ConditionType.New)
                Text("Date").tag(ConditionType.Date)
                Text("Priority").tag(ConditionType.Priority)
                Text("Repeat").tag(ConditionType.Repeat)
            }
            .pickerStyle(.menu)
        }
        
    }
}

struct ConditionView_Previews: PreviewProvider {
    static var previews: some View {
        ConditionView()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
