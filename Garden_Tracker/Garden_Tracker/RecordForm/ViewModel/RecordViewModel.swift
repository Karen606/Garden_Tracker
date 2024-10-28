//
//  RecordViewModel.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 29.10.24.
//

import Foundation

class RecordViewModel {
    static let shared = RecordViewModel()
    @Published var recordModel = RecordModel(id: UUID())
    @Published var plants: [PlantModel] = []
    var isEditing = false
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveRecord(recordModel: recordModel) { error in
            completion(error)
        }
    }
    
    func fetchPlants() {
        CoreDataManager.shared.fetchPlants { [weak self] plants, error in
            guard let self = self else { return }
            self.plants = plants
        }
    }
    
    func clear() {
        recordModel = RecordModel(id: UUID())
        isEditing = false
    }
}
