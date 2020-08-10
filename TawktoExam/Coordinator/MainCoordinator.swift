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
    
    func viewDetails(user: User)
    {
        let detailsVc = UserDetailsViewController.instantiate()
        detailsVc.coordinator = self
        detailsVc.user = user
        navigationController.pushViewController(detailsVc, animated: true)
    }
}
