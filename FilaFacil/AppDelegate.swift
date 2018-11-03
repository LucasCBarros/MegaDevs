//
//  AppDelegate.swift
//  FilaFacil
//
//  Created by Lucas Barros on 22/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import Intents
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    fileprivate func requestAuthorisation() {
        INPreferences.requestSiriAuthorization { _ in }
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Personlayze status bar
        application.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = false
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        // Finds and saves users DeviceID
//        let deviceID = UIDevice.current.identifierForVendor!.uuidString
       // let deviceToken = Messaging.messaging().fcmToken
        //UserDefaults.standard.set( deviceToken, forKey: "userDeviceID")
        
        if !UIApplication.shared.isRegisteredForRemoteNotifications {
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { accepted, _ in
                    if accepted {
                        PushNotifications.saveSubscriptions(categoriesQuestion: [.developer, .business, .design])
                    }
                })
                // For iOS 10 data message (sent via FCM
                
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            
            application.registerForRemoteNotifications()
            //Messaging.messaging().shouldEstablishDirectChannel = true
        }
        requestAuthorisation()
        
        setupWatchConnectivity()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        PushNotifications.resetBadgeNumber()
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map({ data -> String in
            return String(format: "%02.2hhx", data)
        })
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
    }
    
}

// MARK: - Watch Connectivity
extension AppDelegate: WCSessionDelegate {
    // 1
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WC Session did become inactive")
    }
    
    // 2
    func sessionDidDeactivate(_ session: WCSession) {
        print("WC Session did deactivate")
        WCSession.default.activate()
    }
    
    // 3
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WC Session activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WC Session activated with state: \(activationState.rawValue)")
    }
    
    func setupWatchConnectivity() {
        // 1
        if WCSession.isSupported() {
            // 2
            let session = WCSession.default
            // 3
            session.delegate = self
            // 4
            session.activate()
        }
    }
    
    func sendToWatch() {
        // 1
        if WCSession.isSupported() {
            // 2
            let session = WCSession.default
            if session.isWatchAppInstalled {
                // 4
                do {
                    var dictionary = [String: Any]()
                    dictionary["userID"] = UserDefaults.standard.string(forKey: "userID")
                    dictionary["userType"] = UserDefaults.standard.string(forKey: "userType")
                    try session.updateApplicationContext(dictionary)
                } catch {
                    print("ERROR: \(error)")
                }
            }
        }
    }
    
    // 1
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        // 2
        print("\n\n\nFoi\n\n\n")
        if let request = applicationContext["request"] as? String {
            // 3
            DispatchQueue.main.async {
                switch request {
                case "getUser":
                    self.sendToWatch()
                default:
                    break
                }
            }
        }
    }
    
}
