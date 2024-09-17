//
//  TaskCellViewModel.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation

protocol TaskCellViewModelProtocol {
    var taskName: String { get }
    var completed: Bool { get }
    var date: String { get }
    init(tasksList: Task)
}

protocol TaskSectionViewModelProtocol {
    var rows: [TaskCellViewModelProtocol] { get }
    var numberOfRows: Int { get }
}

class TaskCellViewModel: TaskCellViewModelProtocol {
    
    var taskName: String {
        tasksList.name ?? "task name"
    }
    
    var description: String {
        tasksList.subname ?? "description"
    }
    
    var completed: Bool {
        tasksList.completed
    }
    
    var date: String {
        guard let startDate = tasksList.startDate, let endDate = tasksList.endDate else { return "No date" }
        return formatDateRange(startDate: startDate, endDate: endDate)
    }
    
    private let tasksList: Task
    
    required init(tasksList: Task) {
        self.tasksList = tasksList
    }
    
    private func formatDateRange(startDate: Date, endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        
        let calendar = Calendar.current
        if calendar.isDateInToday(startDate) {
            dateFormatter.dateFormat = "'Today'"
        } else {
            dateFormatter.dateFormat = "MMM d"
        }

        timeFormatter.dateFormat = "h:mm a"

        let dateString = dateFormatter.string(from: startDate)
        let startTimeString = timeFormatter.string(from: startDate)
        let endTimeString = timeFormatter.string(from: endDate)
        
        return "\(dateString) \(startTimeString) - \(endTimeString)"
    }
}

class TaskSectionViewModel: TaskSectionViewModelProtocol {
    var rows: [TaskCellViewModelProtocol] = []
    var numberOfRows: Int {
        rows.count
    }
}
