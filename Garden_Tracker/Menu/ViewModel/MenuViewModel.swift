//
//  MenuViewModel.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 29.10.24.
//

import Foundation

class MenuViewModel {
    static let shared = MenuViewModel()
    @Published var reminders: [ReminderModel] = []
    @Published var records: [RecordModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchRecords { [weak self] records, _ in
            guard let self = self else { return }
            self.records = records
        }
        
        CoreDataManager.shared.fetchReminders { [weak self] reminders, _ in
            guard let self = self else { return }
            self.reminders = reminders
        }
    }
}
