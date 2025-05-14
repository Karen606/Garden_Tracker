//
//  RemindersViewModel.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 29.10.24.
//

import Foundation

class RemindersViewModel {
    static let shared = RemindersViewModel()
    @Published var reminders: [ReminderModel] = []
    private init() {}
    
    func fetchReminders() {
        CoreDataManager.shared.fetchReminders { [weak self] reminders, error in
            guard let self = self else { return }
            self.reminders = reminders
        }
    }
    
    func clear() {
        reminders = []
    }
}
