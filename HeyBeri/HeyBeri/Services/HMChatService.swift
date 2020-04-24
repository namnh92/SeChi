//
//  HMChatService.swift
//  TimXe
//
//  Created by NamNH-D1 on 5/14/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON

enum HMMessageAuthor {
    case driver(content: ChatContentViewModel)
    case user(content: ChatContentViewModel)
}

class HMChatService {
    
    // MARK: - Singleton
    static let instance = HMChatService()
    
    private init() { actionForClosures() }
    
    // MARK: - Closures
    var currentPostId: String?
    var currentUserId: String?
    var didReceiveMessage: ((_ data: ChatContentViewModel) -> Void)?
    var didReceiveMessageAtChatList: (() -> Void)?
    var didReceiveTyping: ((_ text: String?) -> Void)?
    var didLoadHistory: (([HMMessageAuthor]) -> Void)?
    var socketDidConnect: (() -> Void)?
    
    // MARK: - Action
    private func actionForClosures() {
        // Handle response message from Socket
//        HMWebSocketService.instance.connectSocket()
        
        HMWebSocketService.instance.didReceiveJSON = { [weak self] json in
            guard let sSelf = self else {
                return
            }
            print(json)
        }
        
        // Handle Socket connected
        HMWebSocketService.instance.didConnect = { [weak self] in
            self?.socketDidConnect?()
        }
        
        // Handle Socket disconnected
        HMWebSocketService.instance.didDisconnect = {
            HMWebSocketService.instance.connectSocket()
        }
    }
    
    func sendMessage(parameters: [String: String]) {
        guard HMWebSocketService.instance.isSocketConnected() else { return }
        HMWebSocketService.instance.send(name: parameters["content"]!)
    }
}
