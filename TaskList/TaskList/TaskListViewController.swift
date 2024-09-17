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
    func saveNewTask(_ name: String, _ description: String, _ startDate: Date, _ endDate: Date, _ completed: Bool)
}

final class TaskListViewController: UIViewController {
    
    var activeTextField: UITextField?
    
    private lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.register(TaskCell.self, forCellReuseIdentifier: TaskCell.cellID)
        $0.separatorStyle = .none
        $0.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return $0
    }(UITableView(frame: view.bounds, style: .insetGrouped))
    
    private lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 160)
        return headerView
    }()
    
    private lazy var largeTitle: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Today's Task"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return titleLabel
    }()
    
    private lazy var subtitle: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Wednesday, 17 september"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18)
        subtitleLabel.textColor = UIColor.lightGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return subtitleLabel
    }()
    
    private lazy var newTaskButton: UIButton = {
        let newTaskButton = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "+ New Task"
        config.baseForegroundColor = .systemBlue
        config.baseBackgroundColor = UIColor.colorButton
        config.cornerStyle = .large
        config.buttonSize = .large
        newTaskButton.translatesAutoresizingMaskIntoConstraints = false
        newTaskButton.configuration = config
        newTaskButton.addTarget(self, action: #selector(showAlertController), for: .touchUpInside)
        
        return newTaskButton
    }()
    
    private let filterSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["All", "Open", "Closed"])
        return segmentedControl
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
    
    @objc private func filterChanged() {
        
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
    }
    
    // MARK: Setup UI
    private func setupView() {
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = headerView
        
        headerView.addSubview(largeTitle)
        headerView.addSubview(subtitle)
        headerView.addSubview(newTaskButton)
        headerView.addSubview(filterSegmentedControl)
   
        setupSegmentedControl()
        setConstraint()
    }
    
    private func setupSegmentedControl() {
        filterSegmentedControl.selectedSegmentIndex = 0
        filterSegmentedControl.backgroundColor = .clear
        filterSegmentedControl.selectedSegmentTintColor = UIColor(white: 0.95, alpha: 1)
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
                   .foregroundColor: UIColor.gray,
                   .font: UIFont.systemFont(ofSize: 16, weight: .bold)
               ]
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
                   .foregroundColor: UIColor.systemBlue,
                   .font: UIFont.systemFont(ofSize: 16, weight: .bold)
               ]
        
        filterSegmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        filterSegmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
          
        filterSegmentedControl.layer.borderColor = UIColor.clear.cgColor
        filterSegmentedControl.layer.borderWidth = 1
        filterSegmentedControl.apportionsSegmentWidthsByContent = true
        
        let backgroundImage = UIImage(ciImage: .clear)
        filterSegmentedControl.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        
        filterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
    
//        filterSegmentedControl.addTarget(TaskListViewController.self, action: #selector(filterChanged), for: .valueChanged)
    }
    
    func setConstraint() {
        NSLayoutConstraint.activate([
            
            largeTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            largeTitle.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),

            subtitle.leadingAnchor.constraint(equalTo: largeTitle.leadingAnchor),
            subtitle.topAnchor.constraint(equalTo: largeTitle.bottomAnchor, constant: 5),

            newTaskButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            newTaskButton.centerYAnchor.constraint(equalTo: largeTitle.centerYAnchor, constant: 10),
            
            filterSegmentedControl.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 15),
            filterSegmentedControl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            filterSegmentedControl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -64),
            
            filterSegmentedControl.heightAnchor.constraint(equalToConstant: 40),

            headerView.bottomAnchor.constraint(equalTo: filterSegmentedControl.bottomAnchor, constant: 15),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
    }
}
    

// MARK: UITableViewDataCourse
extension TaskListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = sectionViewModel.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.cellID, for: indexPath)
        guard let cell = cell as? TaskCell else { return UITableViewCell() }
        cell.viewModel = cellViewModel
        cell.selectionStyle = .none
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//            let headerView = UIView()
//            headerView.backgroundColor = UIColor.clear
//        
//            return headerView
//        }
}

// MARK: - UITableViewDelegate
extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didTapCell(at: indexPath)
    }
}

// MARK: TaskListViewInputProtocol
extension TaskListViewController: TaskListViewInputProtocol {
    func reloadData(for section: TaskSectionViewModel) {
        sectionViewModel = section
        tableView.reloadData()
    }
    
}
