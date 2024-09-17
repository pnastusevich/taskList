//
//  TaskInAPI.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation

struct TasksInAPI: Decodable {
    
    let todos: [Tasks]
    
}

struct Tasks: Decodable {
    let todo: String
    let completed: Bool
}
