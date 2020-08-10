//
//  UnitOfWork.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 7/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import CoreData

class UnitOfWork {
    /// The NSManagedObjectContext instance to be used for performing the unit of work.
    private let context: NSManagedObjectContext

    /// Book repository instance.
    let userRepository: UserRepository
    let userDetailsRepository: UserDetailsRepository
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.userRepository = UserRepository(context: context)
        self.userDetailsRepository = UserDetailsRepository(context: context)
    }

    /// Save the NSManagedObjectContext.
    @discardableResult func saveChanges() -> Result<Bool, Error> {
        do {
            try context.save()
            return .success(true)
        } catch {
            context.rollback()
            return .failure(error)
        }
    }
}
