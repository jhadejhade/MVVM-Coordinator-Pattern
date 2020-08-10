//
//  UserDetails.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 7/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation

class UserDetail: Codable, UserDetailsElementModel {
    var cellType: UserDetailsElementType = .detailCell
    
    let login: String?
    let id: Int?
    let nodeId: String?
    let avatarUrl: String?
    let gravatarId: String?
    let url: String?
    let htmlUrl: String?
    let followersUrl: String?
    let followingUrl: String?
    let gistsUrl: String?
    let starredUrl: String?
    let subscriptionsUrl: String?
    let organizationsUrl: String?
    let reposUrl: String?
    let eventsUrl: String?
    let receivedEventsUrl: String?
    let type: String?
    let siteAdmin: Bool = false
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let hireable: String?
    let bio: String?
    let twitterUsername: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let createdAt: Date
    let updatedAt: Date
    var note: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeId
        case avatarUrl
        case gravatarId
        case url
        case htmlUrl
        case followersUrl
        case followingUrl
        case gistsUrl
        case starredUrl
        case subscriptionsUrl
        case organizationsUrl
        case reposUrl
        case eventsUrl
        case receivedEventsUrl
        case type
        case siteAdmin
        case name
        case company
        case blog
        case location
        case email
        case hireable
        case bio
        case twitterUsername
        case publicRepos
        case publicGists
        case followers
        case following
        case createdAt
        case updatedAt
        case note
    }
    
    internal init(cellType: UserDetailsElementType = .detailCell, login: String?, id: Int?, nodeId: String?, avatarUrl: String?, gravatarId: String?, url: String?, htmlUrl: String?, followersUrl: String?, followingUrl: String?, gistsUrl: String?, starredUrl: String?, subscriptionsUrl: String?, organizationsUrl: String?, reposUrl: String?, eventsUrl: String?, receivedEventsUrl: String?, type: String?, name: String?, company: String?, blog: String?, location: String?, email: String?, hireable: String?, bio: String?, twitterUsername: String?, publicRepos: Int, publicGists: Int, followers: Int, following: Int, createdAt: Date, updatedAt: Date, note: String?) {
        self.cellType = cellType
        self.login = login
        self.id = id
        self.nodeId = nodeId
        self.avatarUrl = avatarUrl
        self.gravatarId = gravatarId
        self.url = url
        self.htmlUrl = htmlUrl
        self.followersUrl = followersUrl
        self.followingUrl = followingUrl
        self.gistsUrl = gistsUrl
        self.starredUrl = starredUrl
        self.subscriptionsUrl = subscriptionsUrl
        self.organizationsUrl = organizationsUrl
        self.reposUrl = reposUrl
        self.eventsUrl = eventsUrl
        self.receivedEventsUrl = receivedEventsUrl
        self.type = type
        self.name = name
        self.company = company
        self.blog = blog
        self.location = location
        self.email = email
        self.hireable = hireable
        self.bio = bio
        self.twitterUsername = twitterUsername
        self.publicRepos = publicRepos
        self.publicGists = publicGists
        self.followers = followers
        self.following = following
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.note = note
    }
    
}
