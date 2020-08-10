//
//  UserDetailsViewController.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 7/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import UIKit

enum UserDetailsElementType: String {
    case noteCell
    case detailCell
}

protocol UserDetailsElementModel: class {
    var cellType: UserDetailsElementType { get set }
    ///This closure gets call everytime the network status changes
}

protocol UserDetailsElementCell: class {
    func configure(model: UserDetailsElementModel)
    var textViewChanged: ((_ textView: UITextView) -> Void)? { get set}
}
class UserDetailsViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!
    
    var detailIndex = 0
    var user: User!
    private var userDetailsViewModel = UserDetailsViewModel()
    
    var delegate: UserController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = StringConstants.detailsTitle
        configureTable()
        addObservers()
        //for querying into core data
        self.userDetailsViewModel.user = self.user
        //get initial data
        getDetails()
        self.networkStatusChanged = { (status) in
            //refresh data as soon as we are connected to the net
            self.getDetails()
        }
        let logoutBarButtonItem = UIBarButtonItem(title: StringConstants.saveTitle, style: .done, target: self, action: #selector(updateData))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    @objc func DismissKeyboard(){
        //Causes the view to resign from the status of first responder.
        view.endEditing(true)
    }
    
    @objc func updateData(){
        //this is important because we are only saving the text data from note textview on end edit
        view.endEditing(true)
        self.userDetailsViewModel.updateUserDetails { (result) in
            self.coordinator?.showSuccessAlert()
            self.delegate?.updateNote(at: self.detailIndex, note: self.userDetailsViewModel.userDetails!.note!)
        }
    }
    
    func addObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(with:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(with:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func removeObservers()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getDetails()
    {
        userDetailsViewModel.fetchUserDetails(username: self.user.name) { (result) in
            switch (result)
            {
            case .success(_):
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureTable(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.register(UINib(nibName: String(describing: InformationTableViewCell.self), bundle: nil), forCellReuseIdentifier: UserDetailsElementType.detailCell.rawValue)
        tableView.register(UINib(nibName: String(describing: NoteCellTableViewCell.self), bundle: nil), forCellReuseIdentifier: UserDetailsElementType.noteCell.rawValue)
        tableView.register(UINib(nibName: String(describing: DetailHeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DetailHeaderTableViewCell.self))
    }
    
    @objc func keyboardDidShow(with notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        var aRect = self.view.frame
        aRect.size.height -= keyboardFrame.height
        
        self.tableView.scrollToRow(at: IndexPath(row: self.userDetailsViewModel.generalInfoDataSource().count - 1, section: 0), at: .middle, animated: true)
    }
    
    @objc func keyboardWillHide(with notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
}


extension UserDetailsViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDetailsViewModel.generalInfoDataSource().count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.height * 0.3 //set the header height to 30% of the superview's height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView.dequeueReusableCell(withIdentifier: String(describing: DetailHeaderTableViewCell.self) ) as! DetailHeaderTableViewCell
        
        headerView.configure(userDetails: userDetailsViewModel.userDetails)
        
        return headerView.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataSource = userDetailsViewModel.generalInfoDataSource()[indexPath.row]
        let identifier = dataSource.cellType.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UserDetailsElementCell
        
        cell.configure(model: dataSource)
        cell.textViewChanged = { (textView) in
            self.userDetailsViewModel.userDetails?.note = textView.text
        }
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
