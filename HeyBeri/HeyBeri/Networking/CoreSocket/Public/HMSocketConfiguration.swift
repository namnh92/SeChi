//
//  HMSocketConfiguration.swift
//  TimXe
//
//  Created by NamNH-D1 on 5/8/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMSocketConfiguration {

    // Base wss
    static var wssUrl: String {
        var clientId = ""
        if let savedSenderId = HMSharedData.chatBotSenderId {
            clientId = savedSenderId
        } else {
            clientId = generateClientId()
            HMSharedData.chatBotSenderId = clientId
        }
        return "wss://viettelgroup.ai/voice/api/asr/v1/ws/decode_online?content-type=audio/x-raw,+layout=(string)interleaved,+rate=(int)16000,+format=(string)S16LE,+channels=(int)1&token=\(HMConstants.viettelSpeechToTextAPIKey)"
    }
    
    static var httpUrl: String {
        return ""
    }
}

// MARK: - Supporting functions
extension HMSocketConfiguration {
    static func generateClientId() -> String {
        let baseRandomId = String.randomStringWith(type: .numericDigitsAndLetters, length: 20) + HMConstants.chatBotToken
        if let md5 = baseRandomId.md5 { return md5 }
        return baseRandomId
    }
}
