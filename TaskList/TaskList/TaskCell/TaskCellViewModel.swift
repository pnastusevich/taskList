//
//  TaskCellViewModel.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation

protocol TaskCellViewModelProtocol {
    var cellHeight: Double { get }
    var taskName: String { get }
    var idTask: Int { get }
    var completed: Bool { get }
    var date: String { get }
    init(tasksList: Task)
}

protocol TaskSectionViewModelProtocol {
    var rows: [TaskCellViewModelProtocol] { get }
    var numberOfRows: Int { get }
}

class TaskCellViewModel: TaskCellViewModelProtocol {
    
    var cellHeight: Double {
        100
    }
    
    var taskName: String {
        tasksList.name ?? "task name"
    }
    
    var idTask: Int {
        Int(tasksList.id)
    }
    
    var completed: Bool {
        tasksList.completed
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: tasksList.date!)
    }
    
    var description: String {
        tasksList.subname ?? "description"
    }
    
    private let tasksList: Task
    
    required init(tasksList: Task) {
        self.tasksList = tasksList
    }
}

class TaskSectionViewModel: TaskSectionViewModelProtocol {
    var rows: [TaskCellViewModelProtocol] = []
    var numberOfRows: Int {
        rows.count
    }
}
