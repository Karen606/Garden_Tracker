//
//  RemindersViewController.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 29.10.24.
//

import UIKit
import Combine

class RemindersViewController: UIViewController {
    @IBOutlet weak var remindersBgView: UIView!
    @IBOutlet weak var remindersTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableViewheightConst: NSLayoutConstraint!
    private let viewModel = RemindersViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchReminders()
    }
    
    func setupUI() {
        self.setNavigationTitle(title: "Reminders")
        remindersTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        remindersTableView.layer.cornerRadius = 6
        remindersTableView.delegate = self
        remindersTableView.dataSource = self
        remindersTableView.register(UINib(nibName: "ReminderTableViewCell", bundle: nil), forCellReuseIdentifier: "ReminderTableViewCell")
    }
    
    func subscribe() {
        viewModel.$reminders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reminders in
                guard let self = self else { return }
                self.remindersTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newSize = change?[.newKey] as? CGSize {
                updateTableViewHeight(newSize: newSize)
                remindersBgView.isHidden = newSize.height == 0
            }
        }
    }
    
    private func updateTableViewHeight(newSize: CGSize) {
        tableViewheightConst.constant = newSize.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func clickedAdd(_ sender: UIButton) {
        let reminderFormVC = ReminderViewController(nibName: "ReminderViewController", bundle: nil)
        reminderFormVC.complition = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchReminders()
        }
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(reminderFormVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}

extension RemindersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTableViewCell", for: indexPath) as! ReminderTableViewCell
        cell.setupData(reminder: viewModel.reminders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
