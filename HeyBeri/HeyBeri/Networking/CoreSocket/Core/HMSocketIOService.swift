//
//  HMSocketIOService.swift
//  TimXe
//
//  Created by NamNH-D1 on 5/15/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON

class HMSocketIOService {
    
    static let instance = HMSocketIOService()
    
    private let manager = SocketManager(socketURL: URL(string: HMSocketConfiguration.httpUrl)!, config: [.log(true), .compress, .reconnects(true)])
    private var socket: SocketIOClient?
    var isSocketConnected: Bool = false
    
    // MARK: - Closures
    var didReceiveMessage: ((_ data: JSON) -> Void)?
    var didConnect: (() -> Void)?
    var didDisconnect: (() -> Void)?
    
    // MARK: - Init & deinit
        private init() {
            if socket == nil {
                socket = manager.defaultSocket
                handler()
                print("-> [SocketIO] URL: \(HMSocketConfiguration.httpUrl)")
            }
        }
        
        // MARK: - Socket action
        func establishConnection() {
            print("-> [SocketIO] is connecting...")
            socket?.connect()
        }
        
        func closeConnection() {
            print("-> [SocketIO] is disconnected!")
            socket?.disconnect()
    //        socket = nil
            isSocketConnected = false
        }
        
        func handler() {
            socket?.on(clientEvent: .connect, callback: {_,_ in
                print("-> [SocketIO] is connected...")
                self.didConnect?()
                self.isSocketConnected = true
            })

            socket?.on(clientEvent: .disconnect, callback: {_,_ in
                print("-> [SocketIO] is disconnected...")
    //            self.didDisconnect?()
                self.isSocketConnected = false
            })
            
            receiveHandler()
        }
    
    func receiveHandler() {
        socket?.on("vnj_send_chat", callback: { (data, ack) in
            print(data)
            if let data = data[0] as? String {
                let json = JSON(parseJSON: data)
                self.didReceiveMessage?(JSON(parseJSON: data))
                print(json)
            }
        })
    }
    
    func sendHandler(parameters: [String: Any]) {
        var param = parameters
        param["time"] = Date().stringBy(format: "yyyy-MM-dd HH:mm:ss")
        let emitParam = JSON(["event": "vnj_chat",
                              "data": param])
        socket?.emit("vnj_chat", with: [emitParam.rawString(.utf8, options: .prettyPrinted)!], completion: {
            
        })
    }
}
