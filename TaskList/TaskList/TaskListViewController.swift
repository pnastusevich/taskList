//
//  ViewController.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import UIKit

protocol TaskListViewInputProtocol: AnyObject {
}

protocol TaskListViewOutputProtocol {
    init(view: TaskListViewInputProtocol)
    func viewDidLoad()
    func didTapCell(at indexPath: IndexPath)
}

final class TaskListViewController: UIViewController {
    
    private lazy var addTaskBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .save,
                               target: self,
                               action: #selector(addTask))
    }()
    
    var presenter: TaskListViewOutputProtocol!
    
    private var configurator: TaskListConfiguratorInputProtocol = TaskListConfigurator()
    private var sectionViewModel: TaskSectionViewModelProtocol = TaskSectionViewModel()
    
// MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(withView: self)
        setupView()
        presenter.viewDidLoad()
    }
    
    @objc private func addTask() {
        
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func setupView() {
        
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: )
        view.backgroundColor = .white
        setupNavigationBar()
    }
    

    // MARK: Setup UI
    private func setupNavigationBar() {
        title = "Today's Task"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = addTaskBarButton
    }
}

// MARK: UITableViewDataCourse
extension TaskListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = sectionViewModel.rows[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath)
        guard let cell = cell as? TaskCell else { return UITableViewCell() }
        cell.viewModel = cellViewModel
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didTapCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sectionViewModel.rows[indexPath.row].cellHeight
    }
    
}

// MARK: TaskListViewInputProtocol
extension TaskListViewController: TaskListViewInputProtocol {
    
}
