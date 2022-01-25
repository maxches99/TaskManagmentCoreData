//
//  Task.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 15.01.2022.
//

import SwiftUI

struct TaskModel: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
