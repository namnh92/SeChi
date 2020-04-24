//
//  HMOneSignalNotificationService.swift
//  TimXe
//
//  Created by NamNH-D1 on 5/14/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import OneSignal

class HMOneSignalNotificationService: NSObject {
    
    static let shared = HMOneSignalNotificationService()
    
    private override init() { }
    
    func registerOneSignal(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            
            print("Received Notification: \(notification!.payload.notificationID)")
            print("launchURL = \(notification?.payload.launchURL ?? "None")")
            print("content_available = \(notification?.payload.contentAvailable ?? false)")
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload? = result?.notification.payload
            
            print("Message = \(payload!.body)")
            print("badge number = \(payload?.badge ?? 0)")
            print("notification sound = \(payload?.sound ?? "None")")
            
            if let additionalData = result!.notification.payload!.additionalData {
                print("additionalData = \(additionalData)")
            }
        }
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true, ]
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: HMConstants.oneSignalAPIKey, handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
        // Add your AppDelegate as an obsserver
        OneSignal.add(self as OSPermissionObserver)
        
        OneSignal.add(self as OSSubscriptionObserver)
    }
    
    func sendTag(userId: String?) {
        guard let userId = userId else { return }
        let tags: [AnyHashable : Any] = [
            "id" : userId]
        
        OneSignal.sendTags(tags, onSuccess: { result in
            print("Tags sent - \(result!)")
        }) { error in
            print("Error sending tags: \(error?.localizedDescription ?? "None")")
        }
    }
    
    func sendPush() {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userId = status.subscriptionStatus.userId
        OneSignal.postNotification(["contents": ["en": "Test Message"], "include_player_ids": [userId]])
    }
}

extension HMOneSignalNotificationService: OSPermissionObserver {
    
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
        // prints out all properties
        print("PermissionStateChanges: \n\(stateChanges)")
    }
    
}

extension HMOneSignalNotificationService: OSSubscriptionObserver {
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
    }
}

