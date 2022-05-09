//
//  TypeOfNotification.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 13.04.2022.
//

import Foundation

enum TypeOfNotification: Int {
    case endless = 0
    case date = 1
    
    var title: String {
        switch self {
        case .endless:
            return "Никогда"
        case .date:
            return "Дата окончания"
        }
    }
}
