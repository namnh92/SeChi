//
//  AppDelegate.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 3/13/19.
//  Copyright © 2019 Hypertech. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Firebase cloud message
        Messaging.messaging().delegate = self
        
        // Config iqkeyboard
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // config
        settingNaviBarBG()
        settingTabBarBG()
        
        // Init root viewcontroller
        HMSystemBoots.instance.changeRoot(window: &window, rootController: HMRootTabBarController.instance)
        
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
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    // MARK: - Private method
    private func settingNaviBarBG() {
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//        // Sets shadow (line below the bar) to a blank image
//        UINavigationBar.appearance().shadowImage = UIImage().createSelectionIndicator(color: UIColor.navBarShadowColor, size: CGSize(width: HMSystemInfo.screenWidth, height: 1.0))
//        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = .white
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = false
        if #available(iOS 11, *) {}
        else {
            //            UINavigationBar.appearance().isTranslucent = false
        }
    }
    
    private func settingTabBarBG() {
        if #available(iOS 11, *) {}
        else {
            //            UITabBar.appearance().isTranslucent = false
        }
    }
}

// MARK: - Notification handle
extension AppDelegate : MessagingDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        HMNotificationServices.instance.parseDeviceToken(data: deviceToken)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        guard let userInfo = notification.userInfo else { return }
        HMNotificationServices.instance.received(notification: userInfo, application: application, isRemoteNoti: false)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        HMNotificationServices.instance.received(notification: userInfo, application: application, isRemoteNoti: true)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        HMNotificationServices.instance.sendTokenToServer(token: fcmToken, servicesType: .FCM)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
    }
}
