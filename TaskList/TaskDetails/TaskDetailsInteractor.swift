//
//  TaskDetailsInteractor.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation


protocol TaskDetailsInteractorInputProtocol {
  
    init(presenter: TaskDetailsInteractorOutputProtocol, task: Task)
    func provideTaskDetails()
    func updateTask(_ name: String, _ description: String, _ startDate: String, _ endDate: String)
}

protocol TaskDetailsInteractorOutputProtocol: AnyObject {
    func receiveTaskDetails(with dataStore: TaskDetailsDataStore)
}

final class TaskDetailsInteractor: TaskDetailsInteractorInputProtocol {
    
    weak var taskListPresenter: TaskListPresenterProtocol?
    
    private unowned let presenter: TaskDetailsInteractorOutputProtocol
    private let task: Task
    
    required init(presenter: TaskDetailsInteractorOutputProtocol, task: Task) {
        self.presenter = presenter
        self.task = task
    }
    
    func updateTask(_ name: String, _ description: String, _ startDate: String, _ endDate: String) {
        
        if let startDate = self.convertToDate(from: startDate),
           let endDate = self.convertToDate(from: endDate) {
            StorageManager.shared.update(task, name, description, startDate, endDate, false)

            taskListPresenter?.updateTask(task)
        }
    }
    
    func convertToDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.date(from: dateString)
    }
    
    func provideTaskDetails() {
        guard let name = task.name,
              let description = task.subname,
              let startDate = task.startDate,
              let endDate = task.endDate else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let date = formatter.string(from: startDate)
        let dateEnd = formatter.string(from: endDate)
        
        let dataStore = TaskDetailsDataStore(
            taskName: name,
            description: description,
            startDate: date,
            endData: dateEnd,
            isFavorite: task.isComplete)
        
        presenter.receiveTaskDetails(with: dataStore)
    }

}
