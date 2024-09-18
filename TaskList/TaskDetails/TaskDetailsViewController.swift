//
//  TaskDetailsViewController.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import UIKit

protocol TaskDetailsViewInputProtocol: AnyObject {
    func displayTaskName(with title: String)
    func displaySubtitle(with title: String)
    func displayStartDate(with title: String)
    func displayEndDate(with title: String)
}

protocol TaskDetailsViewOutputProtocol {
    init(view: TaskDetailsViewInputProtocol)
    func showDetails()
    func updateTask(_ name: String,_ description: String,_ startDate: String,_ endDate: String)
}



final class TaskDetailsViewController: UIViewController {
    
    var activeTextField: UITextField?
    
    var onDataUpdate: (() -> Void)?
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name task"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var subtitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Descrption task"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var startDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Start date task"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.inputView = self.createDatePicker(textField: textField, mode: .dateAndTime)
        
        return textField
    }()
    
    private lazy var endDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "End date task"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.inputView = self.createDatePicker(textField: textField, mode: .dateAndTime)
        
        return textField
    }()
    
    private lazy var saveTaskButton: UIButton = {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "Save Task"
        let button = UIButton(configuration: buttonConfig, primaryAction: UIAction { [unowned self] _ in
            saveTask()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var returnButton: UIButton = {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "Cancel"
        buttonConfig.background.backgroundColor = .darkGray
        let button = UIButton(configuration: buttonConfig, primaryAction: UIAction { [unowned self] _ in
            cancelTask()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var presenter: TaskDetailsViewOutputProtocol!

    
    // MARK: - Life Cycle view
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSubviews(nameTextField, subtitleTextField, startDateTextField, endDateTextField, saveTaskButton, returnButton)
        setConstraints()
        presenter.showDetails()
        setupNavigationBar()
    }
    
    @objc private func saveTask() {
        let nameTF = nameTextField.text ?? ""
        let subtitleTF = subtitleTextField.text ?? ""
        let startDateTF = startDateTextField.text ?? ""
        let endDateTF = endDateTextField.text ?? ""
        
        presenter.updateTask(nameTF, subtitleTF, startDateTF, endDateTF)
        onDataUpdate?()

        dismiss(animated: true)

    }

    @objc private func cancelTask() {
        dismiss(animated: true)
    }
    
    private func setupNavigationBar() {
        title = "Edit Task"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem:.cancel,
            target: self,
            action: #selector(cancelTask))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTask))
       }
}

// MARK: - Setup UI
private extension TaskDetailsViewController {
    
    func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate(
        [
            nameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            subtitleTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
            subtitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            subtitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            subtitleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            startDateTextField.topAnchor.constraint(equalTo: subtitleTextField.bottomAnchor, constant: 30),
            startDateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            startDateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            startDateTextField.heightAnchor.constraint(equalToConstant: 40),
            
            endDateTextField.topAnchor.constraint(equalTo: startDateTextField.bottomAnchor, constant: 30),
            endDateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            endDateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            endDateTextField.heightAnchor.constraint(equalToConstant: 40),

            saveTaskButton.topAnchor.constraint(equalTo: endDateTextField.bottomAnchor, constant: 40),
            saveTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            saveTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            saveTaskButton.heightAnchor.constraint(equalToConstant: 40),

            returnButton.topAnchor.constraint(equalTo: saveTaskButton.bottomAnchor, constant: 30),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            returnButton.heightAnchor.constraint(equalToConstant: 40),
            
        ]
        )
    }
}

// MARK: - TaskDetailsViewInputProtocol
extension TaskDetailsViewController: TaskDetailsViewInputProtocol {
    func displayTaskName(with title: String) {
        nameTextField.text = title
    }
    
    func displaySubtitle(with title: String) {
        subtitleTextField.text = title
    }
    
    func displayStartDate(with title: String) {
        startDateTextField.text = title
    }
    
    func displayEndDate(with title: String) {
        endDateTextField.text = title
    }
    
}

// MARK: - Setup DatePicker

extension TaskDetailsViewController {
    
    func createDatePicker(textField: UITextField, mode: UIDatePicker.Mode) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        textField.inputAccessoryView = toolbar
        return datePicker
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        if let textField = activeTextField {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            textField.text = formatter.string(from: sender.date)
        }
    }
    
    @objc func donePressed() {
        if let textField = activeTextField, let datePicker = textField.inputView as? UIDatePicker {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            textField.text = formatter.string(from: datePicker.date)
        }
        view.endEditing(true)
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}
