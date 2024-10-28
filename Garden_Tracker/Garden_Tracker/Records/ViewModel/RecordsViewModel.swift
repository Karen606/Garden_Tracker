//
//  RecordsViewModel.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 29.10.24.
//

import Foundation

class RecordsViewModel {
    static let shared = RecordsViewModel()
    @Published var records: [RecordModel] = []
    private init() {}
    
    func fetchRecords() {
        CoreDataManager.shared.fetchRecords { [weak self] records, error in
            guard let self = self else { return }
            self.records = records
        }
    }
    
    func removeRecord(by id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.removeRecord(by: id) { error in
            completion(error)
        }
    }
    
    func clear() {
        records = []
    }
}
