//
//  User.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 6/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation

class User: Codable, UsersElementModel {
    
    let id: Int
    let nodeId: String
    let gravatarId: String
    let name: String
    let avatarUrl: String
    let url: String
    let htmlUrl: String
    let followersUrl: String
    let followingUrl: String
    let gistsUrl: String
    let starredUrl: String
    let subscriptionsUrl: String
    let organizationsUrl: String
    let reposUrl: String
    let eventsUrl: String
    let receivedEventsUrl: String
    let type: String
    let siteAdmin: Bool
    
    // add default value since we are just using this locally so the compiler won't complain that we did not include this in the CodingKeys
    var note: String = ""
    
    ///This will determine the cell type on our table
    var currentIndex: Int = 0 {
        didSet {
            let modulo = currentIndex % 4
            if (note.isEmpty && modulo != 0)
            { cellType = .normalCell }
            else if (modulo == 0)
            { cellType = .invertedCell }
            else { cellType = .noteCell }
        }
    }
    var cellType: UsersElementType = .normalCell
    
    // do this if you wanted a different property name in our model, in this case the 'login' json key will be parsed on property 'name'
    enum CodingKeys: String, CodingKey {
        case name = "login"
        case id
        case nodeId
        case gravatarId
        case avatarUrl
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
    }
    
    init(id: Int, nodeId: String, gravatarId: String, name: String, avatarUrl: String, url: String, htmlUrl: String, followersUrl: String, followingUrl: String, gistsUrl: String, starredUrl: String, subscriptionsUrl: String, organizationsUrl: String, reposUrl: String, eventsUrl: String, receivedEventsUrl: String, type: String, siteAdmin: Bool, note: String = "", currentIndex: Int = 0, cellType: UsersElementType = .normalCell) {
        self.id = id
        self.nodeId = nodeId
        self.gravatarId = gravatarId
        self.name = name
        self.avatarUrl = avatarUrl
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
        self.siteAdmin = siteAdmin
        self.note = note
        self.currentIndex = currentIndex
        self.cellType = cellType
    }
    
}
