//
//  UserDetailsRepository.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 9/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation
import CoreData

protocol UserDetailsRepositoryInterface {
    func getDetails(predicate: NSPredicate?) -> Result<UserDetail?, Error>
    func create(userDetails: UserDetail) -> Result<Bool, Error>
    func update(userDetails: UserDetail) -> Result<Bool, Error>
}

class UserDetailsRepository {
    
    private let repository: CoreDataRepository<UserDetailsEntity>
    
    init(context: NSManagedObjectContext) {
        self.repository = CoreDataRepository<UserDetailsEntity>(managedObjectContext: context)
    }
}


extension UserDetailsRepository: UserDetailsRepositoryInterface {
    @discardableResult func getDetails(predicate: NSPredicate?) -> Result<UserDetail?, Error> {
        let result = self.repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
            
        case .success(let usersDetailsEntity):
            let users = usersDetailsEntity.map { usersDetailsEntity -> UserDetail in
                return usersDetailsEntity.toDomainModel()
            }
            return .success(users.first)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func create(userDetails: UserDetail) -> Result<Bool, Error> {
        let result = repository.create()
        switch result {
        case .success(let userMO):
            // Update the userDetails properties.
            userMO.avatarUrl = userDetails.avatarUrl
            userMO.id = Int32(userDetails.id!)
            userMO.nodeId = userDetails.nodeId
            userMO.gravatarId = userDetails.gravatarId
            userMO.name = userDetails.name
            userMO.url = userDetails.url
            userMO.htmlUrl = userDetails.htmlUrl
            userMO.followersUrl = userDetails.followersUrl
            userMO.followingUrl = userDetails.followingUrl
            userMO.gistsUrl = userDetails.gistsUrl
            userMO.starredUrl = userDetails.starredUrl
            userMO.subscriptionsUrl = userDetails.subscriptionsUrl
            userMO.organizationsUrl = userDetails.organizationsUrl
            userMO.reposUrl = userDetails.reposUrl
            userMO.eventsUrl = userDetails.eventsUrl
            userMO.receivedEventsUrl = userDetails.receivedEventsUrl
            userMO.type = userDetails.type
            userMO.siteAdmin = userDetails.siteAdmin
            userMO.login = userDetails.login
            userMO.company = userDetails.company
            userMO.blog = userDetails.blog
            userMO.location = userDetails.location
            userMO.email = userDetails.email
            userMO.hireable = userDetails.hireable
            userMO.bio = userDetails.bio
            userMO.twitterUsername = userDetails.twitterUsername
            userMO.publishGists = Int32(userDetails.publicGists)
            userMO.publicRepos = Int32(userDetails.publicRepos)
            userMO.following = Int32(userDetails.following)
            userMO.followers = Int32(userDetails.followers)
            userMO.createdAt = userDetails.createdAt
            userMO.updatedAt = userDetails.updatedAt
//            userMO.note = userDetails.note
            return .success(true)
        case .failure(let error):
            // Return the Core Data error.
            return .failure(error)
        }
    }
    
    func update(userDetails: UserDetail) -> Result<Bool, Error> {
        let result = repository.update(id: userDetails.id!)
        switch result {
        case .success(let entity):
            if let userMO = entity
            {
               // Update the userDetails properties.
                userMO.avatarUrl = userDetails.avatarUrl
                userMO.id = Int32(userDetails.id!)
                userMO.nodeId = userDetails.nodeId
                userMO.gravatarId = userDetails.gravatarId
                userMO.name = userDetails.name
                userMO.url = userDetails.url
                userMO.htmlUrl = userDetails.htmlUrl
                userMO.followersUrl = userDetails.followersUrl
                userMO.followingUrl = userDetails.followingUrl
                userMO.gistsUrl = userDetails.gistsUrl
                userMO.starredUrl = userDetails.starredUrl
                userMO.subscriptionsUrl = userDetails.subscriptionsUrl
                userMO.organizationsUrl = userDetails.organizationsUrl
                userMO.reposUrl = userDetails.reposUrl
                userMO.eventsUrl = userDetails.eventsUrl
                userMO.receivedEventsUrl = userDetails.receivedEventsUrl
                userMO.type = userDetails.type
                userMO.siteAdmin = userDetails.siteAdmin
                userMO.login = userDetails.login
                userMO.company = userDetails.company
                userMO.blog = userDetails.blog
                userMO.location = userDetails.location
                userMO.email = userDetails.email
                userMO.hireable = userDetails.hireable
                userMO.bio = userDetails.bio
                userMO.twitterUsername = userDetails.twitterUsername
                userMO.publishGists = Int32(userDetails.publicGists)
                userMO.publicRepos = Int32(userDetails.publicRepos)
                userMO.following = Int32(userDetails.following)
                userMO.followers = Int32(userDetails.followers)
                userMO.createdAt = userDetails.createdAt
                userMO.updatedAt = userDetails.updatedAt
//                userMO.note = userDetails.note
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
extension UserDetailsEntity: DomainModel {
    
    typealias DomainModelType = UserDetail
    
    func toDomainModel() -> UserDetail {
        return UserDetail(login: login,
                          id: Int(id),
                          nodeId: nodeId,
                          avatarUrl: avatarUrl,
                          gravatarId: gravatarId,
                          url: url,
                          htmlUrl: htmlUrl,
                          followersUrl: followersUrl,
                          followingUrl: followingUrl,
                          gistsUrl: gistsUrl,
                          starredUrl: starredUrl,
                          subscriptionsUrl: subscriptionsUrl,
                          organizationsUrl: organizationsUrl,
                          reposUrl: reposUrl,
                          eventsUrl: eventsUrl,
                          receivedEventsUrl: receivedEventsUrl,
                          type: type,
                          name: name,
                          company: company,
                          blog: blog,
                          location: location,
                          email: email,
                          hireable: hireable,
                          bio: bio,
                          twitterUsername: twitterUsername,
                          publicRepos: Int(publicRepos),
                          publicGists: Int(publishGists),
                          followers: Int(followers),
                          following: Int(following),
                          createdAt: createdAt!,
                          updatedAt: updatedAt!,
                          note: "")
    }
}
