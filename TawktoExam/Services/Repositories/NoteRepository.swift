//
//  NoteEntity.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 10/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation
import CoreData

protocol NoteRepositoryInterface {
    func getDetails(predicate: NSPredicate?) -> Result<UserDetail?, Error>
    func create(userDetails: UserDetail) -> Result<Bool, Error>
    func update(userDetails: UserDetail) -> Result<Bool, Error>
}

class NoteRepository {
    
    private let repository: CoreDataRepository<NoteEntity>
    
    init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<NoteEntity>(managedObjectContext: context)
    }
}

