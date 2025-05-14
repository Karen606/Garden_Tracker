//
//  PlantsViewController.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 28.10.24.
//

import UIKit
import Combine

class PlantsViewController: UIViewController {

    @IBOutlet weak var plantsBgView: UIView!
    @IBOutlet weak var plantsTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableViewheightConst: NSLayoutConstraint!
    private let viewModel = PlantsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchPlants()
    }
    
    func setupUI() {
        self.setNavigationTitle(title: "My plants")
        plantsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        plantsTableView.layer.cornerRadius = 6
        plantsTableView.delegate = self
        plantsTableView.dataSource = self
        plantsTableView.register(UINib(nibName: "PlantTableViewCell", bundle: nil), forCellReuseIdentifier: "PlantTableViewCell")
    }
    
    func subscribe() {
        viewModel.$plants
            .receive(on: DispatchQueue.main)
            .sink { [weak self] plants in
                guard let self = self else { return }
                self.plantsTableView.reloadData()
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
        let plantFormVC = PlantFormViewController(nibName: "PlantFormViewController", bundle: nil)
        plantFormVC.complition = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchPlants()
        }
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(plantFormVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}

extension PlantsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantTableViewCell", for: indexPath) as! PlantTableViewCell
        cell.setupData(plant: viewModel.plants[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
