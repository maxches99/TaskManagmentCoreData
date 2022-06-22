//
//  AnalyticsHelper.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 22.06.2022.
//

import Foundation
import FirebaseAnalytics

public class AnalyticsHelper {
    
    public static var shared = AnalyticsHelper()
    
    var eventDates: [String: Date] = [:]
    public var userID: String?
    
    var uuid: String = UUID().uuidString
    
    var utmParams: [String: String] = [:]
    
    public func log(_ type: AnalyticsType) {
        let analyticParameters = getParameters(type)
        Analytics.logEvent(type.eventName, parameters: analyticParameters)
    }
    
    func getParameters(_ type: AnalyticsType) -> [String: Any] {
        
        eventDates[type.eventName] = Date()
        
        var firebaseParams = [String: Any]()
        firebaseParams["sessionID"] = uuid
        firebaseParams["date"] = Date().description
        
        if let userID = userID {
            firebaseParams["userID"] = userID
        }
        
        switch type {
        case .AppLaunched:
            utmParams.keys.forEach {
                firebaseParams[$0] = utmParams[$0]
            }
        case .TaskSaved(let task):
            firebaseParams["TaskDate"] = task.taskDate?.formatted(date: .numeric, time: .omitted)
            firebaseParams["Priority"] = task.priority
        default:
            break
        }
        return firebaseParams
    }
    
    public func setUTMparameters(_ params: [String: String]) {
        self.utmParams = params
    }
}

public enum AnalyticsType {
    
    //MARK: Main events
    case AppLaunched
    
    //MARK: Task events
    case TaskSaved(Task)
}

extension AnalyticsType {
    public var eventName: String {
        switch self {
        case .AppLaunched:
            return "AppLaunched"
        case .TaskSaved:
            return "TaskSaved"
        }
    }
}
