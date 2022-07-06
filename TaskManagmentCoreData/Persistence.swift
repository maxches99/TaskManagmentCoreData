//
//  Persistence.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 15.01.2022.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<2 {
            let newItem = Task(context: viewContext)
            newItem.taskTitle = "Task title 1"
            newItem.taskDescription = "Task Description"
            newItem.priority = 0
        }
        for _ in 0..<2 {
            let newItem = Task(context: viewContext)
            newItem.taskDate = Date()
            newItem.taskTitle = "Task title 2"
            newItem.taskDescription = "Task Description"
            newItem.priority = 1
        }
        for _ in 0..<2 {
            let newItem = Task(context: viewContext)
            newItem.taskDate = Date()
            newItem.taskTitle = "Task title 3"
            newItem.taskDescription = "Task Description"
            newItem.priority = 2
        }
        for _ in 0..<2 {
            let newItem = Task(context: viewContext)
            newItem.taskDate = nil
            newItem.taskTitle = "Task title 4"
            newItem.taskDescription = "Task Description"
            newItem.priority = 2
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "TaskManagmentCoreData")
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
