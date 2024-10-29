//
//  ViewController.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 28.10.24.
//

import UIKit
import Combine

class MenuViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recordsTextView: UITextView!
    @IBOutlet weak var remindersTextView: UITextView!
    @IBOutlet weak var recordsBgView: UIView!
    @IBOutlet weak var remindersBgView: UIView!
    private let viewModel = MenuViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = .angkor(size: 28)
        recordsTextView.font = .montserratRegular(size: 20)
        remindersTextView.font = .montserratRegular(size: 20)
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    func subscribe() {
        viewModel.$records
            .receive(on: DispatchQueue.main)
            .sink { [weak self] records in
                guard let self = self else { return }
                self.recordsBgView.isHidden = records.isEmpty
                let text = records.map { record in
                    "\(record.name ?? "Unnamed") - \(record.info ?? "No info")"
                }.joined(separator: "\n")
                self.recordsTextView.text = text
            }
            .store(in: &cancellables)
        
        viewModel.$reminders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reminders in
                guard let self = self else { return }
                self.remindersBgView.isHidden = reminders.isEmpty
                let text = reminders.map { reminder in
                    "\(reminder.info ?? "")  \(reminder.date?.toString(format: "dd/MM/yy") ?? "")"
                }.joined(separator: "\n")
                self.remindersTextView.text = text
            }
            .store(in: &cancellables)
    }
}

