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

//    func saveParty(partyModel: PartyModel, completion: @escaping (Error?) -> Void) {
//        let id = partyModel.id ?? UUID()
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Party> = Party.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                let party: Party
//
//                if let existingParty = results.first {
//                    party = existingParty
//                } else {
//                    party = Party(context: backgroundContext)
//                    party.id = id
//                }
//                party.name = partyModel.name
//                party.location = partyModel.location
//                party.theme = partyModel.theme
//                party.date = partyModel.date
//                
//                if let guestsModel = partyModel.guests {
//                    var guests = Set<Guest>()
//                    for guest in guestsModel {
//                        let guestEntity = Guest(context: backgroundContext)
//                        guestEntity.id = guest.id
//                        guestEntity.name = guest.name
//                        guestEntity.email = guest.email
//                        guestEntity.phone = guest.phone
//                        guestEntity.photo = guest.photo
//                        guestEntity.isConfirmed = guest.isConfirmed
//                        guests.insert(guestEntity)
//                    }
//                    party.guests = guests as NSSet
//                } else {
//                    party.guests = nil
//                }
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
//    func fetchParties(completion: @escaping ([PartyModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Party> = Party.fetchRequest()
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                var partyModels: [PartyModel] = []
//                for result in results {
//                    let partyModel = PartyModel(id: result.id, name: result.name, location: result.location, theme: result.theme, date: result.date)
//                    partyModels.append(partyModel)
//                }
//                completion(partyModels, nil)
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
    
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
}

