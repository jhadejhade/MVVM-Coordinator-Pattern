//
//  CoreDataProvider.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 7/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation
import CoreData


class CoreDataContextProvider {
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // The persistent container
    private var persistentContainer: NSPersistentContainer
    
    init(completion: ((Error?) -> Void)? = nil) {
        // Create a persistent container
        persistentContainer = NSPersistentContainer(name: "TawktoExam")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
                
            }
            completion?(error)
        }
    }
    
    // Creates a context for background work
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
