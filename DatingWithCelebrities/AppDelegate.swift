//
//  AppDelegate.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 30/10/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        tryImportInitialData()
        
        LocalNotification.shared.checkUserNotificationOnStartup(application)

        preformActionWhenNotificationAvailable(launchOptions: launchOptions)
        
        Me().coin = 1000
        
        return true
    }

    // MARK: User notification
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .init(rawValue: 0) {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // TODO: odstanit
//        fatalError(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        LocalNotification.shared.handleRecievedDatingWhenAppActive(notificationId: notification.userInfo![kLocalNotificationId] as! Int)
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        if notification.category == LocalNotification.shared.kDatingCategory {
            LocalNotification.shared.handleDatingAction(identifier: identifier!, notification: notification)
        }
        completionHandler()
    }
    
    // MARK: Install Data
    
    func tryImportInitialData() {
        let kInitialDataVersion = "initial_data_version"
        let version = 1
        
        if version != UserDefaults.standard.integer(forKey: kInitialDataVersion) {
            
            let dataController = DataController.shared
            
            // remove old
            let datingTypeFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DatingTypeEntity.self))
            let celebrityFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CelebrityEntity.self))
            do {
                let datingTypes = try dataController.managedObjectContext.fetch(datingTypeFetchRequest) as! [NSManagedObject]
                let celebrities = try dataController.managedObjectContext.fetch(celebrityFetchRequest) as! [NSManagedObject]
                
                datingTypes.forEach({ dataController.managedObjectContext.delete($0) })
                celebrities.forEach({ dataController.managedObjectContext.delete($0) })
            } catch  {
                fatalError()
            }
            
            // import
            var needPersist = false
            

            
            //MARK: celebrity import
            guard  let celebrityPath = Bundle.main.path(forResource: "Celebrity", ofType: "plist") else {
                fatalError("Nenajdeny fajl Celebrity.plist")
            }
            guard let celebrityData = NSArray(contentsOfFile: celebrityPath) as? [[String : AnyObject]] else {
                fatalError("Neviem precitat celebrity data")
            }
            for celebrityRow in celebrityData {
                needPersist = true
                
                let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: CelebrityEntity.self), into: dataController.managedObjectContext) as! CelebrityEntity
                entity.id = (celebrityRow["id"] as! NSNumber).int16Value
                entity.name = celebrityRow["name"] as? String
            }
            
            if needPersist {
                do {
                    try dataController.managedObjectContext.save()
                } catch {
                    fatalError("nepodarilo sa ulozit initial data")
                }
                
                needPersist = false
            }
            
            
            
            //MARK: dating type import
            guard  let datingPath = Bundle.main.path(forResource: "DatingType", ofType: "plist") else {
                fatalError("Nenajdeny fajl DatingType.plist")
            }
            guard let datingData = NSArray(contentsOfFile: datingPath) as? [[String : AnyObject]] else {
                fatalError("Neviem precitat dating data")
            }
            
            for datingRow in datingData {
                needPersist = true
                
                let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: DatingTypeEntity.self), into: dataController.managedObjectContext) as! DatingTypeEntity
                entity.id = (datingRow["id"] as! NSNumber).int16Value
                entity.name = datingRow["name"] as? String
                entity.price = (datingRow["price"] as! NSNumber).int16Value
            }
            
            if needPersist {
                do {
                    try dataController.managedObjectContext.save()
                } catch {
                    fatalError("nepodarilo sa ulozit initial data")
                }
                
                needPersist = false
            }
            
            UserDefaults.standard.set(version, forKey: kInitialDataVersion)
        }
    }
}

