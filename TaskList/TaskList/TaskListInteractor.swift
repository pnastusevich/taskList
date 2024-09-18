//
//  TaskListInteractor.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation

protocol TaskListInteractorInputProtocol {
    init(presenter: TaskListInteractorOutputProtocol)
    func fetchTaskList()
    func saveNewTask(_ name: String, _ description: String, _ startDate: Date, _ endDate: Date, _ completed: Bool)
    func deleteTask(_ task: Task)
    func doneTask(_ task: Task?)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func taskListDidReceive(with dataStore: TaskListDataStore)
    func newSavedTaskDidReceived(with newTask: Task)
}

final class TaskListInteractor: TaskListInteractorInputProtocol {
   
    private unowned let presenter: TaskListInteractorOutputProtocol
    
    required init(presenter: TaskListInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    // MARK: - Work in Data - CRUD
    func saveNewTask(_ name: String, _ description: String, _ startDate: Date, _ endDate: Date, _ isComplete: Bool) {
        StorageManager.shared.create(name, description, startDate, endDate, isComplete) { task in
            presenter.newSavedTaskDidReceived(with: task)
        }
    }

    func fetchTaskList() {
        StorageManager.shared.fetchData { taskList in
            switch taskList {
            case .success(let taskList):
                if taskList.isEmpty {
                    fetchTasksFromAPI()
                } else {
                    let dataStore = TaskListDataStore(tasksList: taskList)
                    presenter.taskListDidReceive(with: dataStore)
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
    func fetchTasksFromAPI() {
        NetworkManager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let taskList):
                var newTasks: [Task] = []
                let currentDate = Date()
                
                for task in taskList.todos {
                    StorageManager.shared.create(task.todo, "description", currentDate, currentDate, task.completed) { task in
                        newTasks.append(task)
                    }
                }
                let dataStore = TaskListDataStore(tasksList: newTasks)
                presenter.taskListDidReceive(with: dataStore)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func doneTask(_ task: Task?) {
        guard let task = task else { return }
        StorageManager.shared.done(task)
    }
    
    func deleteTask(_ task: Task) {
        StorageManager.shared.delete(task)
    }
    
}

