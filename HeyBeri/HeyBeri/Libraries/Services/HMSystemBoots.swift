//
//  HMSystemBoots.swift
//  Develop
//
//  Created by Nguyễn Nam on 4/8/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMSystemBoots {
    // MARK: - Singleton
    static let instance = HMSystemBoots()
    
    // MARK: - Variables
    weak var appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    // MARK: - Actions
    func changeRoot(window: inout UIWindow?, rootController: UIViewController) {
        // Setup app's window
        guard window == nil else {
            window?.rootViewController = rootController
            window?.makeKeyAndVisible()
            return
        }
        window = UIWindow(frame: HMSystemInfo.screenBounds)
        window?.backgroundColor = .clear
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }
}
