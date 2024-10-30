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
    @IBOutlet weak var recordsBgView: UIView!
    @IBOutlet weak var remindersBgView: UIView!
    @IBOutlet weak var recordsTableView: UITableView!
    @IBOutlet weak var remindersTableView: UITableView!
    private let viewModel = MenuViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = .angkor(size: 28)
        setupUI()
//        recordsTextView.font = .montserratRegular(size: 20)
//        remindersTextView.font = .montserratRegular(size: 20)
        subscribe()
    }
    
    func setupUI() {
        recordsTableView.delegate = self
        recordsTableView.dataSource = self
        recordsTableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        remindersTableView.delegate = self
        remindersTableView.dataSource = self
        remindersTableView.register(UINib(nibName: "ReminderTableViewCell", bundle: nil), forCellReuseIdentifier: "ReminderTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }
    
    func subscribe() {
        viewModel.$records
            .receive(on: DispatchQueue.main)
            .sink { [weak self] records in
                guard let self = self else { return }
                self.recordsTableView.reloadData()
                self.recordsBgView.isHidden = records.isEmpty
//                let text = records.map { record in
//                    "\(record.name ?? "Unnamed") - \(record.info ?? "No info")"
//                }.joined(separator: "\n")
//                self.recordsTextView.text = text
            }
            .store(in: &cancellables)
        
        viewModel.$reminders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reminders in
                guard let self = self else { return }
                self.remindersBgView.isHidden = reminders.isEmpty
                self.remindersTableView.reloadData()
//                let text = reminders.map { reminder in
//                    "\(reminder.info ?? "")  \(reminder.date?.toString(format: "dd/MM/yy") ?? "")"
//                }.joined(separator: "\n")
//                self.remindersTextView.text = text
            }
            .store(in: &cancellables)
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recordsTableView {
            return viewModel.records.count
        }
        return viewModel.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == recordsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
            cell.setupData(record: viewModel.records[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTableViewCell", for: indexPath) as! ReminderTableViewCell
            cell.setupData(reminder: viewModel.reminders[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
