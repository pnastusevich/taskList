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
    func create(_ taskName: String,_ description: String,_ taskId: Int,_ date: Date,_ completed: Bool, completion: (SavedTasks) -> Void) {
        let task = SavedTasks(context: viewContext)
        task.name = taskName
        task.overview = description
        task.id = Int64(taskId)
        task.date = date
        task.completed = completed
        saveContext()
        completion(task)
    }
    
    func fetchData(completion: (Result<[SavedTasks], Error>) -> Void) {
        let fetchRequest = SavedTasks.fetchRequest()
        
        do {
            let task = try viewContext.fetch(fetchRequest)
            completion(.success(task))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func update(_ task: SavedTasks,_ taskName: String,_ description: String,_ taskId: Int,_ date: Date,_ completed: Bool) {
        task.name = taskName
        task.overview = description
        task.id = Int64(taskId)
        task.date = date
        task.completed = completed
        saveContext()
    }
    
    func delete(_ task: SavedTasks) {
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




