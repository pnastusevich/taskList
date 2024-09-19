//
//  TaskDetailsConfigurator.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

protocol TaskDetailsConfiguratorInputProtocol {
    func configure(withView view: TaskDetailsViewController, and task: Task)
}

final class TaskDetailsConfigurator: TaskDetailsConfiguratorInputProtocol {
    func configure(withView view: TaskDetailsViewController, and task: Task) {
        let presenter = TaskDetailsPresenter(view: view)
        let interactor = TaskDetailsInteractor(presenter: presenter, task: task)
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
