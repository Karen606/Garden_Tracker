//
//  ReminderFormViewModel.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 29.10.24.
//

import Foundation

class ReminderFormViewModel {
    static let shared = ReminderFormViewModel()
    @Published var reminderModel = ReminderModel(id: UUID())
    @Published var plants: [PlantModel] = []
    var isEditing = false
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveReminder(reminderModel: reminderModel) { error in
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
        reminderModel = ReminderModel(id: UUID())
        isEditing = false
    }
}
