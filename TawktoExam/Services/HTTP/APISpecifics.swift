//
//  APISpecifics.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 7/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation

enum APIError: Error
{
    case invalidURL
    case parsingError
    case serverError
    case nullParameters
    case noInternetConnection
}

//Add your API calls here
enum API
{
    typealias Parameters = [String: Any]?
    typealias URLParameters = [String: String]?
    
    case users(page: Int)
    case userInfo(username: String)
    
    public var endPoint: String {
        switch self {
        case .users(_):
            return "users"
        case .userInfo(let username):
            return "users/\(username)"
        }
    }
    
    public var method: APIMethod {
        switch self {
        case .users(_):
            return .get
        default:
            return .post
        }
    }
    
    public var httpBodyParams: Parameters
    {
        switch self {
        default:
            return nil
        }
    }
    
    public var urlParams: URLParameters {
        switch self {
        case .users(let page):
            return ["since": String(describing: page)]
        default:
            return nil
        }
    }
}

enum APIMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}
