//
//  HMSocketService.swift
//  TimXe
//
//  Created by NamNH-D1 on 5/8/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON

class HMWebSocketService {

    // MARK: - Singleton
    static let instance = HMWebSocketService()
    
    // MARK: - Variables
    private var socket: WebSocket?
    
    // MARK: - Closures
    var didReceiveJSON: ((_ json: JSON) -> Void)?
    var didConnect: (() -> Void)?
    var didDisconnect: (() -> Void)?
    
    // MARK: - Init & deinit
    init() {
        // Do nothing
    }
    
    // MARK: - Socket action
    func connectSocket() {
        if socket == nil {
            let urlString = HMSocketConfiguration.wssUrl
            guard let url = URL(string: urlString) else { return }
            socket = WebSocket(url: url)
            socket?.delegate = self
            print("-> [Web Socket] URL: \(urlString)")
        }
        socket?.connect()
        print("-> [Web Socket] is connecting...")
    }

    func disconnectSocket() {
        print("-> [Web Socket] is disconnected!")
        socket?.disconnect()
        socket = nil
    }
    
    func write(string: String) {
        print("-> [Web Socket] will write: \(string)")
        socket?.write(string: string)
    }
    
    func isSocketConnected() -> Bool {
        guard let socket = socket else { return false }
        return socket.isConnected
    }
    
    func send(name: String) {
        guard HMWebSocketService.instance.isSocketConnected() else { return }
        var parameters: [String: Any] = [:]
        parameters["type"] = "payload"
        parameters["content"] = "get_started"
        parameters["sender_name"] = name
        if let senderId = HMSharedData.chatBotSenderId {
            parameters["sender_id"] = senderId
        }
        if let jsonString = JSON(parameters).rawString() {
            HMWebSocketService.instance.write(string: jsonString)
        }
    }
}

extension HMWebSocketService: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        print("-> [Web Socket] connected !")
        didConnect?()
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("-> [Web Socket] disconnected !")
        if let error = error {
            print("-> [Web Socket] error: \(error.localizedDescription)")
        }
        didDisconnect?()
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("-> [Web Socket] did receive data:\n\(data)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let json = JSON.init(parseJSON: text)
        print("-> [Web Socket] did receive message:\n\(json)")
        didReceiveJSON?(json)
    }
}
