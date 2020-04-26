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
                if let actionSelected = additionalData["actionSelected"] as? String {
                    switch actionSelected {
                    case "accept":
                        self.send(mess: "Tôi sẽ giúp đỡ")
                    case "cancel":
                        self.send(mess: "Tôi không thể giúp đỡ")
                    default:
                        break
                    }
                }
            }
        }
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true, ]
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: HMConstants.oneSignalAPIKey, handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
        // Add your AppDelegate as an obsserver
        OneSignal.add(self as OSPermissionObserver)
        
        OneSignal.add(self as OSSubscriptionObserver)

        sendPush(objTask: "nhớ mua chuối nhé")
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
    
    func sendPush(objTask: String) {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userId = status.subscriptionStatus.userId
        OneSignal.postNotification(["contents": ["en": #"\#(objTask)"#],
                                    "include_player_ids": [userId],
                                    "buttons": [["id": "id1", "text": "Đồng Ý"]
                                        , ["id": "id2", "text": "Từ Chối"]
                                        , ["id": "id3", "text": "Nhờ Trợ Giúp"]]])
    }
    
    func sendHelpPush(objTask: String) {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userId = status.subscriptionStatus.userId
        OneSignal.postNotification(["contents": ["en": #"\#(objTask)"#],
                                    "include_player_ids": [userId],
                                    "buttons": [["id": "cancel", "text": "Từ chối"],
                                                ["id": "accept", "text": "Đồng ý"]],
                                    "ios_sound": "maybe-next-time.wav"])
    }
    
    func sendPushAskForHelp(objTask: String) {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userId = status.subscriptionStatus.userId
        OneSignal.postNotification(["contents": ["en": #"\#(objTask)"#],
                                    "include_player_ids": [userId],
                                    "buttons": [["id": "id4", "text": "Đồng Ý"]
                                        , ["id": "id5", "text": "Từ Chối"]],                             "ios_sound": "maybe-next-time.wav"])
    }

    
    func sendPushSayThankYou(objName: String, objMessage: String) {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userId = status.subscriptionStatus.userId
        OneSignal.postNotification(["contents": ["en": #"Vợ Mập gửi \#u{2764} cho \#(objName): \#(objMessage)"#],
                                    "include_player_ids": [userId]])
    }
    
    func send(mess: String) {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userId = status.subscriptionStatus.userId
        OneSignal.postNotification(["contents": ["en": #"\#(mess)"#],
        "include_player_ids": [userId]])
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

