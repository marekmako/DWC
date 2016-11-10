//
//  UserNotification.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 31/10/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//


// TODO: odstranit

import UIKit







func preformActionWhenNotificationAvailable(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
    if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String : AnyObject], let payload = notification["aps"] as? [String : String] {
        
    }
}
