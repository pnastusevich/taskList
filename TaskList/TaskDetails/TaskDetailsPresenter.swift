//
//  TaskDetailsPresenter.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation

struct TaskDetailsDataStore {
    let taskName: String
    let description: String
    let startDate: String
    let endData: String
    let isFavorite: Bool
}

final class TaskDetailsPresenter: TaskDetailsViewOutputProtocol {

    var interactor: TaskDetailsInteractorInputProtocol!
    private unowned let view: TaskDetailsViewInputProtocol
    
    private var dataStore: TaskDetailsDataStore?
    
    required init(view: TaskDetailsViewInputProtocol) {
        self.view = view
    }
    
    func updateTask(_ name: String, _ description: String, _ startDate: String, _ endDate: String) {
        interactor.updateTask(name, description, startDate, endDate)
    }

    func showDetails() {
        interactor.provideTaskDetails()
    }
}

// MARK: - CourseDetailsInteractorOutputProtocol
extension TaskDetailsPresenter: TaskDetailsInteractorOutputProtocol {
    func receiveTaskDetails(with dataStore: TaskDetailsDataStore) {
        view.displayTaskName(with: dataStore.taskName)
        view.displaySubtitle(with: dataStore.description)
        view.displayStartDate(with: dataStore.startDate)
        view.displayEndDate(with: dataStore.endData)
    }
}
