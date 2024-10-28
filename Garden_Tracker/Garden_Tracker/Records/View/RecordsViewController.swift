//
//  RecordsViewController.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 28.10.24.
//

import UIKit
import Combine

class RecordsViewController: UIViewController {
    @IBOutlet weak var plantsBgView: UIView!
    @IBOutlet weak var recordsTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableViewheightConst: NSLayoutConstraint!
    private let viewModel = RecordsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchRecords()
    }
    
    func setupUI() {
        self.setNavigationTitle(title: "Records of observations")
        recordsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        recordsTableView.layer.cornerRadius = 6
        self.hidesBottomBarWhenPushed = true
        recordsTableView.delegate = self
        recordsTableView.dataSource = self
        recordsTableView.register(UINib(nibName: "RecordTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordTableViewCell")
    }
    
    func subscribe() {
        viewModel.$records
            .receive(on: DispatchQueue.main)
            .sink { [weak self] records in
                guard let self = self else { return }
                self.recordsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newSize = change?[.newKey] as? CGSize {
                updateTableViewHeight(newSize: newSize)
                plantsBgView.isHidden = newSize.height == 0
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
        let recordFormVC = RecordFormViewController(nibName: "RecordFormViewController", bundle: nil)
        recordFormVC.complition = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchRecords()
        }
        self.navigationController?.pushViewController(recordFormVC, animated: true)
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as! RecordTableViewCell
        cell.setupData(record: viewModel.records[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension RecordsViewController: RecordTableViewCellDelegate {
    func editRecord(record: RecordModel) {
        let recordFormVC = RecordFormViewController(nibName: "RecordFormViewController", bundle: nil)
        RecordViewModel.shared.recordModel = record
        RecordViewModel.shared.isEditing = true
        recordFormVC.complition = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchRecords()
        }
        self.navigationController?.pushViewController(recordFormVC, animated: true)
    }
    
    func removeRecord(recordID: UUID) {
        viewModel.removeRecord(by: recordID) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                viewModel.fetchRecords()
            }
        }
    }
}
