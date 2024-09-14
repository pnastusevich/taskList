//
//  TaskListPresenter.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation

struct TaskListDataStore {
    let tasksListInApi: [Tasks]
}

class TaskListPresenter: TaskListViewOutputProtocol {
    
    var interactor: TaskListInteractorInputProtocol!
    var router: TaskListRouterInputProtocol!

    private unowned let view: TaskListViewInputProtocol
    private var dataStore: TaskListDataStore?
    
    required init(view: any TaskListViewInputProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        interactor.fetchTaskList()
    }
    
    func didTapCell(at indexPath: IndexPath) {
        
    }
}
// MARK: - TaskListInteractorOutoutProtocol
extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func taskListDidReceive(with dataStore: TaskListDataStore) {
        self.dataStore = dataStore
        let section = TaskSectionViewModel()
        dataStore.tasksListInApi.forEach { section.rows.append(TaskCellViewModel(taskListInApi: $0)) }
    }
}
