//
//  AppDelegate.swift
//  IBGPostsSwift
//
//  Created by Fady on 6/22/18.
//  Copyright © 2018 instabug. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setupApplicationWindow()
        self.setupApplicationRootViewController()
        return true
    }
    
    func setupApplicationWindow() {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white;
        self.window?.makeKeyAndVisible()
    }
    
    func setupApplicationRootViewController() {
        let postsViewController = PostsTableViewController()
        let rootNavigationController = UINavigationController(rootViewController: postsViewController)
        self.window?.rootViewController = rootNavigationController
    }
    
}

