//
//  PlantsViewModel.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 28.10.24.
//

import Foundation

class PlantsViewModel {
    static let shared = PlantsViewModel()
    @Published var plants: [PlantModel] = []
    private init() {}
    
    func fetchPlants() {
        CoreDataManager.shared.fetchPlants { [ weak self] plants, error in
            guard let self = self else { return }
            self.plants = plants
        }
    }
}
