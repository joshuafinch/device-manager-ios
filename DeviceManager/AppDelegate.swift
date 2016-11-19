//
//  AppDelegate.swift
//  DeviceManager
//
//  Created by Joshua Finch on 18/11/2016.
//  Copyright © 2016 Joshua Finch. All rights reserved.
//

import UIKit
import Alamofire
import OAuthSwift
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var dataStorageManager: DataStorageManager? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        dataStorageManager = DataStorageManager.shared
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.tintColor = UIColor(red: 233.0/255.0, green: 30.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        
        self.window = window
        
        guard let data = try? Keychain(service: "codes.joshua.devices.trello").getData("credential"),
            let credentialData = data,
            let credential = NSKeyedUnarchiver.unarchiveObject(with: credentialData) as? OAuthSwiftCredential else
        {
            let loginViewController = LoginViewController(dismissCompletion: { [weak self] in
                self?.dataStorageManager?.updateLists()
                self?.setWindowRootViewControllerToTabBarController(window: window)
            })
            window.rootViewController = loginViewController
            window.makeKeyAndVisible()
            loginViewController.authWithTrello()
            return true
        }
        
        SessionManager.default.adapter = OAuthSwiftRequestAdapter(credential)
        dataStorageManager?.updateLists()
        
        setWindowRootViewControllerToTabBarController(window: window)
        
        window.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        dataStorageManager?.updateLists()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK:
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
            return true
        }
        return false
    }
    
    // MARK:
    
    func setWindowRootViewControllerToTabBarController(window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let tabBarController = storyboard.instantiateInitialViewController() as? UITabBarController else {
            fatalError("No tab bar controller")
        }
        
        if let viewControllers = tabBarController.viewControllers, viewControllers.count == 2 {
            if let navigationController = viewControllers[0] as? UINavigationController,
                let projectListViewController = navigationController.viewControllers.first as? ProjectListViewController
            {
                projectListViewController.dataStorageManager = dataStorageManager
            }
        }
        
        window.rootViewController = tabBarController
    }
}

