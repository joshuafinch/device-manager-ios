//
//  AppDelegate.swift
//  DeviceManager
//
//  Created by Joshua Finch on 18/11/2016.
//  Copyright © 2016 Joshua Finch. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var dataStorageManager: DataStorageManager? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        dataStorageManager = DataStorageManager.shared
        dataStorageManager?.updateLists()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let tabBarController = storyboard.instantiateInitialViewController() as? UITabBarController else {
            fatalError("No tab bar controller")
        }
        
        if let viewControllers = tabBarController.viewControllers, viewControllers.count == 2 {
            if let projectListViewController = viewControllers[0] as? ProjectListViewController {
                projectListViewController.dataStorageManager = dataStorageManager
            }
            
//            if let scanAssetTagViewController = viewControllers[1] as? ScanAssetTagViewController {
//                
//            }
        }
        
        window.rootViewController = tabBarController
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


}

