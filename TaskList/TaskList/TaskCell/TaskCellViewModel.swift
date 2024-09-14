//
//  TaskCellViewModel.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation

protocol TaskCellViewModelProtocol {
    var cellIdentifier: String { get }
    var cellHeight: Double { get }
    var taskName: String { get }
    var idTask: Int { get }
    var completed: Bool { get }
    var userId: Int { get }
    init(taskListInApi: Tasks)
}

protocol TaskSectionViewModelProtocol {
    var rows: [TaskCellViewModelProtocol] { get }
    var numberOfRows: Int { get }
}

class TaskCellViewModel: TaskCellViewModelProtocol {
    
    var cellIdentifier: String {
        "TaskCell"
    }
    
    var cellHeight: Double {
        100
    }
    
    var taskName: String {
        taskListInApi.todo
    }
    
    var idTask: Int {
        taskListInApi.id
    }
    
    var completed: Bool {
        taskListInApi.completed
    }
    
    var userId: Int {
        taskListInApi.userId
    }
    
    private let taskListInApi: Tasks
    
    required init(taskListInApi: Tasks) {
        self.taskListInApi = taskListInApi
    }
}

class TaskSectionViewModel: TaskSectionViewModelProtocol {
    var rows: [TaskCellViewModelProtocol] = []
    var numberOfRows: Int {
        rows.count
    }
}
