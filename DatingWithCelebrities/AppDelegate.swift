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
        
        checkUserNotificationOnStartup(application)

        preformActionWhenNotificationAvailable(launchOptions: launchOptions)
        
        Me().coin = 1000
        
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

