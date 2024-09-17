//
//  TaskCellViewModel.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation

protocol TaskCellViewModelProtocol {
    var name: String { get }
    var isComplete: Bool { get set }
    var startDate: Date { get }
    var subname: String { get }
    var endDate: Date { get }
    init(tasksList: Task)
}

protocol TaskSectionViewModelProtocol {
    var rows: [TaskCellViewModelProtocol] { get }
    var numberOfRows: Int { get }
}

class TaskCellViewModel: TaskCellViewModelProtocol {
    
    var name: String {
        tasksList.name ?? "task name"
    }
    
    var subname: String {
        tasksList.subname ?? "description"
    }
    
    var isComplete: Bool {
        get { tasksList.isComplete
        }
        set {
            tasksList.isComplete.toggle()
        }
    }
    
    var startDate: Date {
        tasksList.startDate ?? Date()
    }
    
    var endDate: Date {
        tasksList.endDate ?? Date()
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
