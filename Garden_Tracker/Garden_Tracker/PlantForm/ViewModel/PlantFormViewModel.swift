//
//  PlantFormViewModel.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 28.10.24.
//

import Foundation

class PlantFormViewModel {
    static let shared = PlantFormViewModel()
    @Published var plantModel = PlantModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.savePlant(plantModel: plantModel) { error in
            completion(error)
        }
    }
    
    func clear() {
        plantModel = PlantModel(id: UUID())
    }
}
