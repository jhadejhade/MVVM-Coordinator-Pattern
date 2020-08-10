//
//  APIManager.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 6/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation

class APIManager: NSObject {
    //Singleton init
    static let shared: APIManager = APIManager()
    
    private let baseURL = AppConfig.baseUrlString
    
    /// To make sure we are only instantiating/using API manager via 'shared' across the whole application
    private override init()
    {
        
    }
    
    /// A generic URL Request to cater every API request
    /// Ensures value T is codable which our models is conformed to
    func request<T:Codable>(api: API, method: APIMethod, completion: @escaping((Result<T, APIError>) -> Void))
    {
        if (currentReachabilityStatus == .notReachable)
        {
            completion(.failure(.noInternetConnection))
        } else {
             let path = "\(baseURL)\(api.endPoint)"
                   // make sure we have a valid url
                   guard var urlComponent = URLComponents(string: path)
                       else { completion(.failure(.invalidURL)); return }
                   
                   //make sure URL params is not nil before proceeding otherwise ignore this block
                   if let parameters = api.urlParams
                   {
                       urlComponent.queryItems = parameters.map { key, value in
                           URLQueryItem(name: key, value: value)
                       }
                   }
                   
                   //make sure we have a valid url together with the url params if any
                   guard let url = urlComponent.url
                       else { completion(.failure(.invalidURL)); return }
                   
                   var request = URLRequest(url: url)
                   request.httpMethod = method.rawValue
                   //add common headers if any via
                   //request.allHTTPHeaderFields = [key:value]
                   
                   //make sure httpBody params is not nil before proceeding otherwise ignore this block
                   if let parameters = api.httpBodyParams
                   {
                       do {
                           request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                       } catch {
                           completion(.failure(.parsingError))
                       }
                   }
                   
                   let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                       guard error == nil
                           else {
                               completion(.failure(.serverError)); return }
                       
                       do {
                           // make sure we have a value in the 'data', 'response', 'statusCode is 2XX' and no error before proceeding otherwise .serverError
                           guard let data = data,
                               let response = response as? HTTPURLResponse,
                               (200 ..< 300) ~= response.statusCode,
                               error == nil else {
                                    completion(.failure(.serverError)); return }
                           
                           let decoder = JSONDecoder()
                           // since github api has snakecase naming convention we need to add this so that we would not need to add custom coding keys for our models
                           decoder.keyDecodingStrategy = .convertFromSnakeCase
                           // this line is to cater githubs default date format
                           decoder.dateDecodingStrategy = .iso8601
                           
                           //maps the response data to a generic object
                           let genericObject = try decoder.decode(T.self, from: data)
                           completion(.success(genericObject))
                       } catch{
                           // we had a parsing error
                           print(error)
                            completion(.failure(.parsingError)); return
                       }
                   }
                   
                   dataTask.resume()
        }
       
    }
}
