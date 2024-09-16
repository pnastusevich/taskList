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
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func taskListDidReceive(with dataStore: TaskListDataStore)
}

class TaskListInteractor: TaskListInteractorInputProtocol {

    private unowned let presenter: TaskListInteractorOutputProtocol
    
    required init(presenter: TaskListInteractorOutputProtocol) {
        self.presenter = presenter
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
                    StorageManager.shared.create(task.todo, "description", task.id, currentDate, task.completed) { task in
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
    
}

