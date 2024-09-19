//
//  TaskListCongigurator.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import Foundation

protocol TaskListConfiguratorInputProtocol {
    func configure(withView view: TaskListViewController)
}

final class TaskListConfigurator: TaskListConfiguratorInputProtocol {
    
    func configure(withView view: TaskListViewController) {
        let presenter = TaskListPresenter(view: view)
        let interactor = TaskListInteractor(presenter: presenter)
        let router = TaskListRouter(view: view)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
    
    
}
