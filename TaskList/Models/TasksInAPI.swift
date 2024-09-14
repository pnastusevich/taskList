//
//  TaskInAPI.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation

struct TasksInAPI: Decodable {
    
    let todos: [Tasks]
//    let total: Int
//    let skip: Int
//    let limit: Int
    
}

struct Tasks: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
