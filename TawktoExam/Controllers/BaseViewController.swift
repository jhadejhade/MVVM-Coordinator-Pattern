//
//  BaseViewController.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 7/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import UIKit
import Network

class BaseViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    typealias networkStatusClosure = (_ status: NWPath.Status) -> Void
    ///This closure gets call everytime the network status changes
    var networkStatusChanged: networkStatusClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkCheck.sharedInstance().networkCheckDelegate = self
    }
}

extension BaseViewController: NetworkCheckDelegate {
    func statusDidChange(status: NWPath.Status) {
        networkStatusChanged?(status)
    }
    
}
