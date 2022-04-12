//
//  TypeEndOfRepeat.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 12.04.2022.
//

import Foundation

enum TypeEndOfRepeat: Int {
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
