//
//  UserRepository.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 7/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation
import CoreData

protocol UserRepositoryInterface {
    func getUsers(predicate: NSPredicate?) -> Result<[User], Error>
    func getUser(predicate: NSPredicate?) -> Result<User?, Error>
    func create(user: User) -> Result<Bool, Error>
    func update(user: User) -> Result<Bool, Error>
}

class UserRepository {
    
    private let repository: CoreDataRepository<UserEntity>
    
    init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<UserEntity>(managedObjectContext: context)
    }
}

extension UserRepository: UserRepositoryInterface {
    //use discardableResult to suppress warning in case we don't use the value that's been returned
    /// Get All users based on the predicate filter provided
    @discardableResult func getUsers(predicate: NSPredicate?) -> Result<[User], Error> {
        let result = self.repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
            
        case .success(let usersEntity):
            let users = usersEntity.map { userEntity -> User in
                return userEntity.toDomainModel()
            }
            return .success(users)
        case .failure(let error):
            return .failure(error)
        }
    }
    /// Get UserDetails
    @discardableResult func getUser(predicate: NSPredicate?) -> Result<User?, Error> {
        let result = self.repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
        case .success(let userEntity):
            let user = userEntity.first?.toDomainModel()
            return .success(user)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func create(user: User) -> Result<Bool, Error> {
        let result = repository.create()
        switch result {
        case .success(let userMO):
            // Update the user properties.
            userMO.avatarUrl = user.avatarUrl
            userMO.id = Int32(user.id)
            userMO.nodeId = user.nodeId
            userMO.gravatarId = user.gravatarId
            userMO.name = user.name
            userMO.url = user.url
            userMO.htmlUrl = user.htmlUrl
            userMO.followerUrl = user.followersUrl
            userMO.followingUrl = user.followingUrl
            userMO.gistsUrl = user.gistsUrl
            userMO.starredUrl = user.starredUrl
            userMO.subscriptionsUrl = user.subscriptionsUrl
            userMO.organizationsUrl = user.organizationsUrl
            userMO.reposUrl = user.reposUrl
            userMO.eventsUrl = user.eventsUrl
            userMO.receivedEventsUrl = user.receivedEventsUrl
            userMO.type = user.type
            userMO.siteAdmin = user.siteAdmin
            return .success(true)
            
        case .failure(let error):
            // Return the Core Data error.
            return .failure(error)
        }
    }
    
    func update(user: User) -> Result<Bool, Error> {
        let result = repository.update(id: user.id)
        switch result {
        case .success(let entity):
            if let userMO = entity
            {
                userMO.avatarUrl = user.avatarUrl
                userMO.id = Int32(user.id)
                userMO.nodeId = user.nodeId
                userMO.gravatarId = user.gravatarId
                userMO.name = user.name
                userMO.url = user.url
                userMO.htmlUrl = user.htmlUrl
                userMO.followerUrl = user.followersUrl
                userMO.followingUrl = user.followingUrl
                userMO.gistsUrl = user.gistsUrl
                userMO.starredUrl = user.starredUrl
                userMO.subscriptionsUrl = user.subscriptionsUrl
                userMO.organizationsUrl = user.organizationsUrl
                userMO.reposUrl = user.reposUrl
                userMO.eventsUrl = user.eventsUrl
                userMO.receivedEventsUrl = user.receivedEventsUrl
                userMO.type = user.type
                userMO.siteAdmin = user.siteAdmin
                
                return .success(true)
            } else {
                return .failure(CoreDataError.noDataFound)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}

// Use this extension to transform ManagedObject to our Domain Models (DTOs)
extension UserEntity: DomainModel {
    
    typealias DomainModelType = User
    
    func toDomainModel() -> User {
        return User(id: Int(id),
                    nodeId: nodeId!,
                    gravatarId: gravatarId!,
                    name: name!,
                    avatarUrl: avatarUrl!,
                    url: url!,
                    htmlUrl: htmlUrl!,
                    followersUrl: followerUrl!,
                    followingUrl: followingUrl!,
                    gistsUrl: gistsUrl!,
                    starredUrl: starredUrl!,
                    subscriptionsUrl: subscriptionsUrl!,
                    organizationsUrl: organizationsUrl!,
                    reposUrl: reposUrl!,
                    eventsUrl: eventsUrl!,
                    receivedEventsUrl: receivedEventsUrl!,
                    type: type!,
                    siteAdmin: siteAdmin,
                    note: "",
                    currentIndex: Int(currentIndex))
    }
}
