//
//  ViewController.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import UIKit

protocol TaskListViewInputProtocol: AnyObject {
    
    func reloadData(for section: TaskSectionViewModel)
}

protocol TaskListViewOutputProtocol {
    init(view: TaskListViewInputProtocol)
    func viewDidLoad()
    func didTapCell(at indexPath: IndexPath)
}

final class TaskListViewController: UIViewController {
    
    private let cellID = "TaskCell"
    private let tableView = UITableView()
    
    private lazy var addTaskBarButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "+ New Task",
                               style: .plain,
                               target: self,
                               action: #selector(didTapNewTask))
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
    
    @objc private func didTapNewTask() {
        
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
    }
    
    func setupView() {
        setupNavigationBar()
        
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
//        guard let cellViewModel = sectionViewModel.rows.first else { return }
//        tableView.register(TaskCell.self, forCellReuseIdentifier: cellViewModel.cellIdentifier)
        tableView.register(TaskCell.self, forCellReuseIdentifier: cellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        setConstraint()
    }
    
    func setConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
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

        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
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
    func reloadData(for section: TaskSectionViewModel) {
        sectionViewModel = section
        tableView.reloadData()
    }
    
}
