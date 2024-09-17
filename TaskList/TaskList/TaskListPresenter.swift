//
//  TaskListPresenter.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation

struct TaskListDataStore {
    private let storageManager = StorageManager.shared
    var tasksList: [Task]
    let section = TaskSectionViewModel()
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
    
    func saveNewTask(_ name: String, _ description: String, _ startDate: Date, _ endDate: Date, _ isComplete: Bool) {
        interactor.saveNewTask(name, description, startDate, endDate, isComplete)
    }
    
    func deleteTask(at indexPath: IndexPath) {
        guard let task = dataStore?.tasksList[indexPath.row] else { return }
        
        interactor.deleteTask(task)
        dataStore?.tasksList.remove(at: indexPath.row)
        dataStore?.section.rows.remove(at: indexPath.row)
    }
    
    func doneTasks(at index: Int) {
        
        dataStore?.tasksList[index].isComplete = true

        let taskCellViewModel = dataStore?.section.rows[index] as? TaskCellViewModel
        taskCellViewModel?.isComplete = true
        
        interactor.doneTask(dataStore?.tasksList[index])
        
        view.reloadData(for: dataStore!.section)
    }
  
    func didTapCell(at indexPath: IndexPath) {
        
    }
}
// MARK: - TaskListInteractorOutoutProtocol
extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func taskListDidReceive(with dataStore: TaskListDataStore) {
        self.dataStore = dataStore

        for task in dataStore.tasksList {
            let tasksCellViewModel = TaskCellViewModel(tasksList: task)
            dataStore.section.rows.append(tasksCellViewModel)
        }
        view.reloadData(for: dataStore.section)
    }
    
    func newSavedTaskDidReceived(with newTask: Task) {
        dataStore?.tasksList.append(newTask)
        
        let taskCellViewModel = TaskCellViewModel(tasksList: newTask)
        dataStore?.section.rows.append(taskCellViewModel)
        view.reloadData(for: dataStore!.section)
    }
  
}
