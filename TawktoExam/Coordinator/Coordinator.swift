//
//  Coordinator.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 9/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set}
    
    func start()
}

