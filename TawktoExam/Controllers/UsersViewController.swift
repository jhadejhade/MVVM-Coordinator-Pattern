//
//  UsersViewController.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 6/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import UIKit
import Network

enum UsersElementType: String {
    case normalCell
    case invertedCell
    case noteCell
}

protocol UsersElementModel: class {
    var cellType: UsersElementType { get set}
}

protocol UsersElementCell: class {
    func configure(model: UsersElementModel)
}

protocol UserController {
    func updateNote(at index: Int, note: String)
}
class UsersViewController: BaseViewController, UserController {
    
    var tableView = UITableView()
    
    var userViewModel = UserViewModel()
    
    var lastPage = 0
    var currentVisibleIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = StringConstants.usersTitle
        configureTable()
        
        self.networkStatusChanged = { (status) in
             self.getUsers(page: self.lastPage)
        }
    }
    
    func updateNote(at index: Int, note: String) {
        self.userViewModel.users[index].note = note
        self.tableView.reloadData()
    }
    
    /// Sets the delegate and datasource and then programatically add tableview to the parent view together with its constraint and.
    func configureTable()
    {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        self.view.addSubview(tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
        
        
        tableView.register(NormalUserTableViewCell.self, forCellReuseIdentifier: UsersElementType.normalCell.rawValue)
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: UsersElementType.noteCell.rawValue)
        tableView.register(InvertedTableViewCell.self, forCellReuseIdentifier: UsersElementType.invertedCell.rawValue)
    }
    
    func getUsers(page: Int){
        userViewModel.fetchUsers(page: page) { [weak self] (result) in
            switch result
            {
            case .failure(let error):
                print(error)
            case .success(let responseUsers):
                // if we successfully got a new batch of data reloadTable
                if (responseUsers.count > 0)
                {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                } else {
                    // Hide the tableFooterView, respectively the activity indicator if no new batch was received
                    self?.tableView.tableFooterView = nil
                }
            }
        }
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userViewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user = userViewModel.users[indexPath.row]
        user.currentIndex = indexPath.row + 1
        
        let identifier = user.cellType.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UsersElementCell
        
        cell.configure(model: user)
        
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 // default height of tableview cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        // add loading view if current cell is the last cell
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex{
            //save the last row so we can fetch additional data once connected to the internet
            self.lastPage = lastRowIndex
            if ( currentReachabilityStatus != .notReachable)
            {
                // get new batch of users if any
                getUsers(page: userViewModel.users[lastRowIndex].id)
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.startAnimating()
                spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
                
                tableView.tableFooterView = spinner
                tableView.tableFooterView?.isHidden = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.viewDetails(viewController: self, user: userViewModel.users[indexPath.row], index: indexPath.row)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

           visibleRect.origin = tableView.contentOffset
           visibleRect.size = tableView.bounds.size

           let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = tableView.indexPathForRow(at: visiblePoint) else { return }
        
        currentVisibleIndex = indexPath.row
    }
}
