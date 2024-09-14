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
        NetworkManager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let taskList):
                let dataStore = TaskListDataStore(tasksListInApi: taskList.todos)
                presenter.taskListDidReceive(with: dataStore)
            case .failure(let error):
                print(error)
            }
        
        }
    }
    
}

