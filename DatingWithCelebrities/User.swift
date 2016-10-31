//
//  UserNotification.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 31/10/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit



fileprivate let userDefaults = UserDefaults.standard



func registerForUserNotification(in application: UIApplication) {
    let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
    application.registerUserNotificationSettings(settings)
    
    userDefaults.set(true, forKey: "checkUserNotificationOnStartup")
}



func checkUserNotificationOnStartup(_ application: UIApplication) {
    if userDefaults.bool(forKey: "checkUserNotificationOnStartup") {
        registerForUserNotification(in: application)
    }
}



func preformActionWhenNotificationAvailable(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
    if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String : AnyObject], let payload = notification["aps"] as? [String : String] {
        
    }
}
