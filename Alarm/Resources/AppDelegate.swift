//
//  AppDelegate.swift
//  Alarm
//
//  Created by Zachary Frew on 7/9/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, _) in
            if success {
                print("User allowed alerts.")
            }
        }
        
        return true
    }

}

