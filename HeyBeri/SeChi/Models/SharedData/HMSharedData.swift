//
//  HMSharedData.swift
//  AppStore
//
//  Created by NamNH on 4/23/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMSharedData {
    // Chat Bot sender id
    static var chatBotSenderId: String? {
        get {
            return UserDefaults.standard.value(forKey: "ChatBotSenderId") as? String
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "ChatBotSenderId")
        }
    }
}
