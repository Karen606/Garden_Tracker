//
//  CoreDataManager.swift
//  Garden_Tracker
//
//  Created by Karen Khachatryan on 28.10.24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Garden_Tracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func savePlant(plantModel: PlantModel, completion: @escaping (Error?) -> Void) {
        let id = plantModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let plant: Plant

                if let existingPlant = results.first {
                    plant = existingPlant
                } else {
                    plant = Plant(context: backgroundContext)
                    plant.id = id
                }
                plant.name = plantModel.name
                plant.type = plantModel.type
                plant.boardingDate = plantModel.boardingDate
                plant.harvestDate = plantModel.harvestDate
                plant.light = plantModel.light
                plant.fertilizers = plantModel.fertilizers
                plant.watering = plantModel.watering
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchPlants(completion: @escaping ([PlantModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var plantsModel: [PlantModel] = []
                for result in results {
                    let plantModel = PlantModel(id: result.id, name: result.name, type: result.type, boardingDate: result.boardingDate, harvestDate: result.harvestDate, watering: result.watering, light: result.light, fertilizers: result.fertilizers)
                    plantsModel.append(plantModel)
                }
                completion(plantsModel, nil)
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func saveRecord(recordModel: RecordModel, completion: @escaping (Error?) -> Void) {
        let id = recordModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let record: Record

                if let existingRecord = results.first {
                    record = existingRecord
                } else {
                    record = Record(context: backgroundContext)
                    record.id = id
                }
                record.name = recordModel.name
                record.info = recordModel.info
                record.date = recordModel.date
                record.plantID = recordModel.plantID
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchRecords(completion: @escaping ([RecordModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var recordsModel: [RecordModel] = []
                for result in results {
                    let recordModel = RecordModel(id: result.id, name: result.name, info: result.info, date: result.date, plantID: result.plantID)
                    recordsModel.append(recordModel)
                }
                completion(recordsModel, nil)
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func removeRecord(by id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let record = results.first {
                    backgroundContext.delete(record)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "removeRecord", code: 404, userInfo: [NSLocalizedDescriptionKey: "Record not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func saveReminder(reminderModel: ReminderModel, completion: @escaping (Error?) -> Void) {
        let id = reminderModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let reminder: Reminder

                if let existingReminder = results.first {
                    reminder = existingReminder
                } else {
                    reminder = Reminder(context: backgroundContext)
                    reminder.id = id
                }
                reminder.name = reminderModel.name
                reminder.info = reminderModel.info
                reminder.date = reminderModel.date
                reminder.plantID = reminderModel.plantID
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchReminders(completion: @escaping ([ReminderModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var remindersModel: [ReminderModel] = []
                for result in results {
                    let reminderModel = ReminderModel(id: result.id, name: result.name, info: result.info, date: result.date, plantID: result.plantID)
                    remindersModel.append(reminderModel)
                }
                completion(remindersModel, nil)
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
}

