//
//  UserViewModel.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 6/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation

class UserViewModel {
    
    //init empty array of 'User'
    var users = [User]()
    var lastDataCount = 0
    
    private let userProvider: UserProvider = APIManager.shared
    private let provider = CoreDataContextProvider()
    private let getUserUow: UnitOfWork!
    private let createUserUow: UnitOfWork!
    
    
    init(model: [User]? = nil)
    {
        if let initModel = model
        {
            self.users = initModel
        }
        getUserUow = UnitOfWork(context: provider.viewContext)
        createUserUow = UnitOfWork(context: provider.newBackgroundContext())
    }
}

extension UserViewModel
{
    func fetchUsers(page: Int, completion: @escaping (Result<[User], Error>) -> Void){
        userProvider.getUsers(page: page) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                switch error {
                case .noInternetConnection:
                    //fetch from core data when no internet connection
                    self.users.removeAll()
                    let result = self.getUserUow.userRepository.getUsers(predicate: nil)
                    switch result {
                    case .success(let users):
                        self.users.append(contentsOf: users)
                        self.lastDataCount = self.users.count
                        completion(.success(users))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                default:
                    completion(.failure(error))
                }
            case .success(let responseUsers):
                self.users.append(contentsOf: responseUsers)
                for i in self.lastDataCount...self.users.count - 1 {
                    let result = self.getUserUow.userRepository.getUsers(predicate: NSPredicate(format: "name == %@", self.users[i].name))
                    switch result {
                    case .success(let users):
                        self.users[i].note = users.first?.note ?? ""
                    case .failure(let error):
                        //error fetching notes
                        print(error)
                        break;
                    }
                }
                self.persistData()
                self.lastDataCount = self.users.count
                
                completion(.success(responseUsers))
            }
        }
    }
    
    func persistData(){
        for userToSave in users {
            let result = getUserUow.userRepository.getUser(predicate: NSPredicate(format: "id == %@", userToSave.id.description))
            switch result {
            case .success(let user):
                // safe to add new entry (No Duplicates)
                if (user == nil)
                {
                    _ = createUserUow.userRepository.create(user: userToSave)
                    createUserUow.saveChanges()
                } else {
                   //duplicate entry
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
