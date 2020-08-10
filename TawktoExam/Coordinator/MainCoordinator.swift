//
//  MainCoordinator.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 9/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator
{
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = UsersViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func viewDetails(viewController: UsersViewController, user: User, index: Int)
    {
        let detailsVc = UserDetailsViewController.instantiate()
        detailsVc.coordinator = self
        detailsVc.user = user
        detailsVc.detailIndex = index
        detailsVc.delegate = viewController
        navigationController.pushViewController(detailsVc, animated: true)
    }
    
    func showSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Sucessfully Added a note!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        }))
        navigationController.present(alertController, animated: true, completion: nil)
    }
}
