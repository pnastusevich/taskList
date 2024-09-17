//
//  Extenshion + UIAlertController.swift
//  TaskList
//
//  Created by Паша Настусевич on 17.09.24.
//

import UIKit

extension TaskListViewController {

    @objc func showAlertController() {
        
        let alertController = UIAlertController(title: "New Task", message: "Enter task details", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Task Name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Task Description"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Start Date"
            textField.inputView = self.createDatePicker(textField: textField, mode: .dateAndTime)
        }
        alertController.addTextField { textField in
            textField.placeholder = "End Date"
            textField.inputView = self.createDatePicker(textField: textField, mode: .dateAndTime)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let taskName = alertController.textFields?[0].text ?? ""
            let taskDescription = alertController.textFields?[1].text ?? ""
            
            guard let startDateString = alertController.textFields?[2].text,
                  let endDateString = alertController.textFields?[3].text else { return }
            
            if let startDate = self.convertToDate(from: startDateString),
               let endDate = self.convertToDate(from: endDateString) {
                
                self.presenter.saveNewTask(taskName, taskDescription, startDate, endDate, false)
                
            } else {
                print("Неправильный формат даты")
            }
        }
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
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
    
    func convertToDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.date(from: dateString)
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

extension UIView {
    func findFirstResponder() -> UIResponder? {
        if self.isFirstResponder {
            return self
        }
        
        for subview in self.subviews {
            if let responder = subview.findFirstResponder() {
                return responder
            }
        }
        return nil
    }
}




