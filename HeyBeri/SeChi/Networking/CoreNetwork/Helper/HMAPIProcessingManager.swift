//
//  HMAPIProcessingManager.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 4/5/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Alamofire

class HMAPIProcessingManager {
    
    // MARK: - Singleton
    static let instance = HMAPIProcessingManager()
    
    // MARK: - Variables
    private var processingDispatcherList: [HMAPIDispatcher] = []
    
    // MARK: - Init & deinit
    init() {
        // Init method
    }
    
    // MARK: - Builder
    func add(dispatcher: HMAPIDispatcher) {
        processingDispatcherList.append(dispatcher)
        print("▶︎ [API Processing Manager] Added new request !")
    }
    
    func cancel(dispatcher: HMAPIDispatcher) {
        dispatcher.cancel()
        print("▶︎ [API Processing Manager] Cancelled request for screen: [\(dispatcher.target?.name ?? "none") !")
    }
    
    func cancelAllDispatchers() {
        processingDispatcherList.forEach {
            $0.cancel()
        }
        processingDispatcherList.removeAll()
    }
    
    func cancelAllDispatchersFor(target: UIViewController) {
        let filterDispatcherList = processingDispatcherList.filter({ $0.target == target })
        for dispatcher in filterDispatcherList {
            dispatcher.cancel()
        }
    }
    
    func removeDispatcherFromList(dispatcher: HMAPIDispatcher) {
        if let index = processingDispatcherList.index(where: { $0 === dispatcher }) {
            processingDispatcherList.remove(at: index)
        }
    }
}

extension UIViewController {
    func cancelAllAPIRequests() {
        HMAPIProcessingManager.instance.cancelAllDispatchersFor(target: self)
    }
}
