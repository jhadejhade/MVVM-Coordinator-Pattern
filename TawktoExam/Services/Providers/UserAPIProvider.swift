//
//  UserAPIService.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 6/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation

protocol UserProvider {
    func getUsers(page: Int, completion: @escaping ((Result<[User], APIError>) -> Void))
    func getUserDetails(username: String, completion: @escaping ((Result<UserDetail, APIError>) -> Void))
}
extension APIManager: UserProvider {
    func getUserDetails(username: String, completion: @escaping ((Result<UserDetail, APIError>) -> Void)) {
        request(api: .userInfo(username: username), method: .get, completion: completion)
    }
    
    func getUsers(page: Int, completion: @escaping ((Result<[User], APIError>) -> Void)) {
        request(api: .users(page: page), method: .get, completion: completion)
    }
}
