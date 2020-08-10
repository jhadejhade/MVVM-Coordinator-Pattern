//
//  CoreDataRepository.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 7/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case invalidManagedObjectType
    case noDataFound
}

protocol Repository {
    associatedtype Entity
    
    /// Gets an array of entities.
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error>
    
    /// Creates an entity.
    func create() -> Result<Entity, Error>
    
    /// Deletes an entity.
    func delete(entity: Entity) -> Result<Bool, Error>
    
    /// Updaets an entity
    func update(id: Int) -> Result<Entity?, Error>
}

protocol DomainModel {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
    func setValues(model: DomainModelType)
}
class CoreDataRepository<T: NSManagedObject>: Repository {
    typealias Entity = T
    
    // The NSManagedObjectContext instance to be used for performing the operations.
    private let managedObjectContext: NSManagedObjectContext
    
    /// Designated initializer.
    /// - Parameter managedObjectContext: The NSManagedObjectContext instance to be used for performing the operations.
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    /// Gets an array of NSManagedObject entities.
    func get(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error> {
        // Create a fetch request for the associated NSManagedObjectContext type.
        let fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: Entity.self))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            // Perform the fetch request
            let fetchResults = try managedObjectContext.fetch(fetchRequest)
            return .success(fetchResults)
        } catch {
            return .failure(error)
        }
    }
    
    /// Creates a NSManagedObject entity.
    func create() -> Result<Entity, Error> {
        let className = String(describing: Entity.self)
        guard let managedObject = NSEntityDescription.insertNewObject(forEntityName: className, into: managedObjectContext) as? Entity else {
            return .failure(CoreDataError.invalidManagedObjectType)
        }
        return .success(managedObject)
    }
    
    func update(id: Int) -> Result<Entity?, Error> {
        let className = String(describing: Entity.self)
         let fetchRequest = NSFetchRequest<Entity>(entityName: className)
               //get the user by ID
               fetchRequest.predicate = NSPredicate(format: "id == %@", id.description)
               do {
                   // Perform the fetch request
                   let fetchResults = try managedObjectContext.fetch(fetchRequest)
                return .success(fetchResults.first)
               } catch {
                   return .failure(error)
               }
    }
    
    /// Deletes a NSManagedObject entity.
    func delete(entity: Entity) -> Result<Bool, Error> {
        managedObjectContext.delete(entity)
        return .success(true)
    }
    
}
