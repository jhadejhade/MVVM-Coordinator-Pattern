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
    var isSearching = false
    
    lazy var searchBar:UISearchBar = UISearchBar()
    
    var ogDataSource: [User]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        self.networkStatusChanged = { (status) in
             //refresh data as soon as we are connected to the net
            self.getUsers(page: self.lastPage)
        }
    }
    
    func updateNote(at index: Int, note: String) {
        self.userViewModel.users[index].note = note
        self.tableView.reloadData()
    }
    
    /// Sets the delegate and datasource and then programatically add the views to the parent view together with its constraint
    func configureUI()
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
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = StringConstants.searchPlaceholder
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        self.tableView.keyboardDismissMode = .onDrag
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
                    self?.ogDataSource = self?.userViewModel.users
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        
                    }
                }
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                    self?.tableView.tableFooterView?.isHidden = true
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
            //save the last row so we can fetch additional data once connected to the internet and searching is not enabled
            self.lastPage = lastRowIndex
            if (currentReachabilityStatus != .notReachable && !isSearching)
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
        userViewModel.users[indexPath.row].seen = true
        userViewModel.updateUserDetails(index: indexPath.row) { (result) in
            self.tableView.reloadData()
        }
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

extension UsersViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        //set ogdatasource everytime we strike a key so the search results is always accurate
        self.userViewModel.users = ogDataSource
        self.userViewModel.users = self.userViewModel.users.filter { ($0.name.lowercased() == searchText.lowercased() || $0.name.lowercased().contains(searchText.lowercased())) || ($0.note.lowercased() == searchText.lowercased() || $0.note.lowercased().contains(searchText.lowercased()))}
        if (searchText.isEmpty)
        {
            // put back the og datasource   
            self.userViewModel.users = ogDataSource
            isSearching = false
        }
        
        self.tableView.reloadData()
    }
    
}
