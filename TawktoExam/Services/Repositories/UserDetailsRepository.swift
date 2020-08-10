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
    func getDetails(predicate: NSPredicate?) -> Result<[UserDetail]?, Error>
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
    @discardableResult func getDetails(predicate: NSPredicate?) -> Result<[UserDetail]?, Error> {
        let result = self.repository.get(predicate: predicate, sortDescriptors: nil)
        switch result {
        case .success(let usersDetailsEntity):
            let users = usersDetailsEntity.map { usersDetailsEntity -> UserDetail in
                return usersDetailsEntity.toDomainModel()
            }
            return .success(users)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func create(userDetails: UserDetail) -> Result<Bool, Error> {
        let result = repository.create()
        switch result {
        case .success(let userMO):
            // Update the userDetails properties.
            userMO.setValues(model: userDetails)
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
                userMO.setValues(model: userDetails)
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
    
    func setValues(model: UserDetail) {
        login = model.login
        id = Int32(model.id!)
        nodeId = model.nodeId
        avatarUrl = model.avatarUrl
        gravatarId = model.gravatarId
        url = model.url
        htmlUrl = model.htmlUrl
        followersUrl = model.followersUrl
        followingUrl = model.followingUrl
        gistsUrl = model.gistsUrl
        starredUrl = model.starredUrl
        subscriptionsUrl = model.subscriptionsUrl
        organizationsUrl = model.organizationsUrl
        reposUrl = model.reposUrl
        eventsUrl = model.eventsUrl
        receivedEventsUrl = model.receivedEventsUrl
        type = model.type
        name = model.name
        company = model.company
        blog = model.blog
        location = model.location
        email = model.email
        hireable = model.hireable ?? false
        bio = model.bio
        twitterUsername = model.twitterUsername
        publicRepos = Int32(model.publicRepos)
        publishGists = Int32(model.publicGists)
        followers = Int32(model.followers)
        following = Int32(model.following)
        createdAt = model.createdAt
        updatedAt = model.updatedAt
        note = model.note
    }
    
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
                          note: note)
    }
}
