//
//  StorageManager.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//


import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    func create(_ taskName: String,_ description: String,_ taskId: Int,_ date: Date,_ completed: Bool, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.name = taskName
        task.subname = description
        task.id = Int64(taskId)
        task.date = date
        task.completed = completed
        saveContext()
        completion(task)
    }
    
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let task = try viewContext.fetch(fetchRequest)
            completion(.success(task))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func update(_ task: Task,_ taskName: String,_ description: String,_ taskId: Int,_ date: Date,_ completed: Bool) {
        task.name = taskName
        task.subname = description
        task.id = Int64(taskId)
        task.date = date
        task.completed = completed
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}




