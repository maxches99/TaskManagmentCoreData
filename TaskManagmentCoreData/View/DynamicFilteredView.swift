//
//  DynamicFilteredView.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 17.01.2022.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject {
    
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    init(dateToFilter: Date, @ViewBuilder content: @escaping (T)->Content) {
        
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: dateToFilter)
        let tommorow = calendar.date(byAdding: .day, value: 1, to: today)
        
        let filterKey = "taskDate"
        
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) =< %@", argumentArray: [today, tommorow])
        
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.taskDate, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        Group {
            if request.isEmpty {
                
                Text("No tasks".localizationString)
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
                
            } else {
                
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
            }
        }
    }
}
