//
//  AppDelegate.swift
//  TawktoExam
//
//  Created by Jade Lapuz on 6/8/20.
//  Copyright © 2020 Jade Lapuz. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var coordinator: MainCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // create the main navigation controller to be used for our app
        let navController = UINavigationController()
        
        // send that into our coordinator so that it can display view controllers
        coordinator = MainCoordinator(navigationController: navController)
        
        // tell the coordinator to take over control
        coordinator?.start()
        
        // create a basic UIWindow and activate it
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}

