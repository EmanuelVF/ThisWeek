//
//  AppDelegate.swift
//  ThisWeek
//
//  Created by Emanuel on 26/05/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("D'oh: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        UNUserNotificationCenter.current().delegate = self
        
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
              title: "Done",
              options: UNNotificationActionOptions(rawValue: 0))
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
              title: "Decline",
              options: UNNotificationActionOptions(rawValue: 0))
        // Define the notification type
        let taskCategory =
              UNNotificationCategory(identifier: "ActionAlert",
              actions: [acceptAction, declineAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([taskCategory])
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge,.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        UIApplication.shared.applicationIconBadgeNumber =  UIApplication.shared.applicationIconBadgeNumber - 1
        switch response.actionIdentifier {
            case "ACCEPT_ACTION":
                let notification = Notification(
                    name: .DoneNotification,
                    object: self,
                    userInfo: [NotificationFromUser.DoneNotificationKey : userInfo])
                NotificationCenter.default.post(notification)
             break
               
        case "DECLINE_ACTION":
            let notification = Notification(
                name: .UndoneNotification,
                object: self,
                userInfo: [ NotificationFromUser.UndoneNotificationKey: userInfo])
            NotificationCenter.default.post(notification)
             break
        
        case "com.apple.UNNotificationDefaultActionIdentifier","com.apple.UNNotificationDismissActionIdentifier":
            let notification = Notification(
                name: .UndoneNotification,
                object: self,
                userInfo: [ NotificationFromUser.UndoneNotificationKey: userInfo])
            NotificationCenter.default.post(notification)
             break
          default:
             break
          }
        
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let ckqn = CKQueryNotification(fromRemoteNotificationDictionary: userInfo as! [String : NSObject])
        let notification = Notification(
            name: .CloudKitNotifications,
            object: self,
            userInfo: [CloudKitNotifications.NotificationKey : ckqn!])
        NotificationCenter.default.post(notification)
        completionHandler(.newData)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

