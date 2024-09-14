//
//  TaskListRouter.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation

protocol TaskListRouterInputProtocol {
    init(view: TaskListViewController)
//    func openTaskDetailsViewController(with taskList: TaskInApi)
}

class TaskListRouter: TaskListRouterInputProtocol {
    private unowned let view: TaskListViewController
    
    required init(view: TaskListViewController) {
        self.view = view
    }
    
//    func openTaskDetailsViewController(with taskList: TaskInApi) {
//        view.performSegue(withIdentifier: "showDetails", sender: taskList)
//    }
}
