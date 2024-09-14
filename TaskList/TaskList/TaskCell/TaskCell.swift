//
//  TaskCell.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import UIKit

protocol CellModelRepresentable {
    var viewModel: TaskCellViewModelProtocol? { get }
}

class TaskCell: UITableViewCell, CellModelRepresentable {
    
    var viewModel: TaskCellViewModelProtocol? {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        guard let viewVodel = viewModel as? TaskCellViewModel else { return }
        var content = defaultContentConfiguration()
        content.text = viewModel?.taskName
        content.secondaryText = String(viewVodel.idTask)
        
        contentConfiguration = content
    }
}
