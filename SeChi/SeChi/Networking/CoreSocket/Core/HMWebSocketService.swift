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
import AVFoundation

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
    
    func write(data: Data) {
        print("-> [Web Socket] will write: \(data)")
        socket?.write(data: data)
    }
    
    func isSocketConnected() -> Bool {
        guard let socket = socket else { return false }
        return socket.isConnected
    }
    
    func recognize(assetURL: URL) {
        guard HMWebSocketService.instance.isSocketConnected() else { return }
        let sampleRate: UInt32 = 16000 // 16k sample/sec
        let bitDepth: UInt16 = 16 // 16 bit/sample/channel

        let opts: [AnyHashable : Any] = [:]
        let asset = AVURLAsset(url: assetURL, options: opts as? [String : Any])
        var reader: AVAssetReader? = nil
        do {
            reader = try AVAssetReader(asset: asset)
        } catch {
        }
        let settings = [
            AVFormatIDKey : NSNumber(value: Int32(kAudioFormatLinearPCM)),
            AVSampleRateKey : NSNumber(value: Float(sampleRate)),
            AVLinearPCMBitDepthKey : NSNumber(value: Int32(bitDepth)),
            AVLinearPCMIsNonInterleaved : NSNumber(value: false),
            AVLinearPCMIsFloatKey : NSNumber(value: false),
            AVLinearPCMIsBigEndianKey : NSNumber(value: false)
        ]
        
        var output: AVAssetReaderTrackOutput? = nil
        let object = asset.tracks[0]
            output = AVAssetReaderTrackOutput(
                track: object,
                outputSettings: settings)
        
        if let output = output {
            reader?.add(output)
        }
        reader?.startReading()

        // read the samples from the asset and append them subsequently
        while reader?.status != .completed {
            let buffer = output?.copyNextSampleBuffer()
            if buffer == nil {
                continue
            }
            
            if let buffer = buffer,
                let blockBuffer = CMSampleBufferGetDataBuffer(buffer) {
                let size = CMBlockBufferGetDataLength(blockBuffer)
                if let outBytes = malloc(size) {
                    CMBlockBufferCopyDataBytes(blockBuffer, atOffset: 0, dataLength: size , destination: outBytes)
                    CMSampleBufferInvalidate(buffer)
                    let data = Data(bytes: outBytes, count: size)
                    HMWebSocketService.instance.write(data: data)
                    free(outBytes)
                }
            }
        }
        HMWebSocketService.instance.write(string: "EOS")
    }
    
    func recognize(inputSteam: InputStream) {
        guard HMWebSocketService.instance.isSocketConnected() else { return }
        let bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: 8000)
        var nRead = inputSteam.read(bytes, maxLength: 8000)
        while (nRead != -1) {
            nRead = inputSteam.read(bytes, maxLength: 8000)
            let data = Data(bytes: bytes, count: nRead)
            HMWebSocketService.instance.write(data: data)
            usleep(250)
        }
        HMWebSocketService.instance.write(string: "EOS")
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
