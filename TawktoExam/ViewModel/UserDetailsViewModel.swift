//
//  UserDetails.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 7/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation

enum ObjectError: Error
{
    case noData
}
class UserDetailsViewModel {
    let userProvider: UserProvider = APIManager.shared
    
    var userDetails: UserDetail?
    var username = ""
    
    let getUserDetailsUow: UnitOfWork!
    let createUserDetailsUow: UnitOfWork!
    let provider = CoreDataContextProvider()
    
    init(model: UserDetail? = nil)
    {
        if let initModel = model
        {
            self.userDetails = initModel
        }
        getUserDetailsUow = UnitOfWork(context: provider.viewContext)
        createUserDetailsUow = UnitOfWork(context: provider.newBackgroundContext())
    }
}


extension UserDetailsViewModel
{
    func fetchUserDetails(username: String, completion: @escaping (Result<UserDetail?, Error>) -> Void)
    {
        userProvider.getUserDetails(username: username) { (result) in
            switch result
            {
            case .failure(let error):
                print(error)
                switch error {
                case .noInternetConnection:
                    //fetch from core data when no internet connection
                    let result = self.getUserDetailsUow.userDetailsRepository.getDetails(predicate: NSPredicate(format: "login == %@", username))
                    switch result {
                    case .success(let userDetail):
                        self.userDetails = userDetail
                        completion(.success(userDetail))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                default:
                    completion(.failure(error))
                }
                completion(.failure(error))
            case .success(let userDetails):
                self.userDetails = userDetails
                self.persistData()
                completion(.success(userDetails))
            }
        }
    }
    
    func updateUserDetails(completion: @escaping (Result<Bool, Error>) -> Void){
        guard let userDetails = self.userDetails
            else { completion(.failure(ObjectError.noData)); return }
        // update on the details
        let result = createUserDetailsUow.userDetailsRepository.update(userDetails: userDetails)
        switch result {
        case .success(let success):
            //only save change if we successfully got the data to update
            createUserDetailsUow.saveChanges()
            completion(.success(success))
        case .failure(let error):
            completion(.failure(error))
        }
        // update user
    }
    
    //Convert our model into an array of tuples so we can use it as a datasource in the table
    func generalInfoDataSource() -> [CellDetail]
    {
        var dataSource = [CellDetail]()
        if let details = userDetails
        {
            dataSource.append(CellDetail(label: "Name", value: details.name ?? "N/A"))
            dataSource.append(CellDetail(label: "Company", value: details.company ?? "N/A"))
            dataSource.append(CellDetail(label: "Login Name", value: details.login ?? "N/A"))
            dataSource.append(CellDetail(label: "Login Type", value: details.type ?? "N/A"))
            dataSource.append(CellDetail(label: "Note", value: details.note ?? StringConstants.notePlaceholder))
        }
        
        return dataSource
    }
    
    func persistData(){
        guard let userDetails = self.userDetails
            else {return}
        
        let result = getUserDetailsUow.userDetailsRepository.getDetails(predicate: NSPredicate(format: "id == %@", userDetails.id!.description))
        switch result {
        case .success(let user):
            // safe to add new entry (No Duplicates)
            if (user == nil)
            {
                let result = createUserDetailsUow.userDetailsRepository.create(userDetails: userDetails)
                switch result {
                case .success(_):
                    //only save change if we successfully got the data to update
                    createUserDetailsUow.saveChanges()
                case .failure(let error):
                    print(error)
                }
            } else {
                print("Duplicate Entry for user \(String(describing: user?.name))")
            }
        case .failure(let error):
            print(error)
        }
    }
}
