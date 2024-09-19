//
//  TaskCell.swift
//  TaskList
//
//  Created by Паша Настусевич on 14.09.24.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
    func didTapCompleteButton(in cell: TaskCell)
}

protocol CellModelRepresentable {
    var viewModel: TaskCellViewModelProtocol? { get }
}

final class TaskCell: UITableViewCell, CellModelRepresentable {
    
    static let cellID = "TaskCell"
    weak var delegate: TaskCellDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let isCompleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let separatorView: UIView = {
        let imageView = UIView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        return containerView
    }()
    
    var viewModel: TaskCellViewModelProtocol? {
        didSet {
            updateView()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        isCompleteButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateView() {
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        guard let viewModel = viewModel as? TaskCellViewModel else { return }
        
        titleLabel.text = viewModel.name
        subtitleLabel.text = viewModel.subname
        timeLabel.text = formatDateRange(startDate: viewModel.startDate,
                                         endDate: viewModel.endDate)
        
        if viewModel.isComplete {
            isCompleteButton.setImage(UIImage(systemName: "checkmark.circle.fill"),for: .normal)
            isCompleteButton.tintColor = .blue
            
            let attributedString = NSAttributedString(
                string: viewModel.name,
                attributes: [
                    .foregroundColor: UIColor.lightGray
                ]
            )
            titleLabel.attributedText = attributedString
        } else {
            isCompleteButton.setImage(UIImage(systemName: "circle"), for: .normal)
            isCompleteButton.tintColor = .gray
            
            titleLabel.attributedText = nil
            titleLabel.text = viewModel.name
            titleLabel.textColor = .black
        }
    }
    
    @objc private func didTapCompleteButton() {
        guard let viewModel = viewModel as? TaskCellViewModel else { return }
        viewModel.isComplete.toggle()
        updateView()
        delegate?.didTapCompleteButton(in: self)
    }
    
    private func formatDateRange(startDate: Date, endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        
        let calendar = Calendar.current
        if calendar.isDateInToday(startDate) {
            dateFormatter.dateFormat = "'Today'"
        } else {
            dateFormatter.dateFormat = "MMM d"
        }
        timeFormatter.dateFormat = "h:mm a"
        
        let dateString = dateFormatter.string(from: startDate)
        let startTimeString = timeFormatter.string(from: startDate)
        let endTimeString = timeFormatter.string(from: endDate)
        
        return "\(dateString) \(startTimeString) - \(endTimeString)"
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(isCompleteButton)
        containerView.addSubview(separatorView)
        
        NSLayoutConstraint.activate(
            [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -80),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            separatorView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 35),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -35),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            timeLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
            timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            timeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            isCompleteButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -23),
            isCompleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            isCompleteButton.widthAnchor.constraint(equalToConstant: 30),
            isCompleteButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        )
    }
}
