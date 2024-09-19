//
//  TaskListRouter.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import UIKit

protocol TaskListRouterInputProtocol {
    init(view: TaskListViewController)
    func openTaskDetailsViewController(with task: Task)
}

final class TaskListRouter: TaskListRouterInputProtocol {
    private unowned let view: TaskListViewController
    
    required init(view: TaskListViewController) {
        self.view = view
    }
    
    func openTaskDetailsViewController(with task: Task) {
        let taskDetailsVC = TaskDetailsViewController()
        let navController = UINavigationController(rootViewController: taskDetailsVC)
                  
        let configurator: TaskDetailsConfiguratorInputProtocol = TaskDetailsConfigurator()
        configurator.configure(withView: taskDetailsVC, and: task)
        
        taskDetailsVC.onDataUpdate = { [weak self] in
            self?.view.reloadData()
        }
              
        view.present(navController, animated: true, completion: nil)
    }
}
