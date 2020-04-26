//
//  HMAPIConfiguration.swift
//  TimXe
//
//  Created by NamNH-D1 on 5/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HMAPIConfiguration {

    static var baseUrl: String {
        #if DEVELOP || STAGING
        return "http://chapp.vn/vnjapan/api"
        #else
        return "http://chapp.vn/vnjapan/api"
        #endif
    }
    
    static var httpHeaders: HTTPHeaders {
        return [:]
    }
    
    
    static var chatBotURL: String {
        return "https://v3-api.fpt.ai/api/v3/"
    }
    
    static var httpChatBotHeaders: HTTPHeaders {
        return ["Authorization": "Bearer \(HMConstants.chatBotToken)"]
    }
    
    static var viettelAIURL: String {
        return "https://viettelgroup.ai/voice/api"
    }
    
    static var viettelAINLPURL: String {
        return "https://viettelgroup.ai/nlp/api/v1"
    }
    
    static var httpSpeechToTextHeader: HTTPHeaders {
        return ["token": HMConstants.viettelSpeechToTextAPIKey]
    }
    
    static var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    static var timeout: TimeInterval {
        return 30
    }
}
