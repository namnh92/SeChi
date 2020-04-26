//
//  HMTexToSpeechAPI.swift
//  SeChi
//
//  Created by Nguyễn Nam on 4/24/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class HMTexToSpeechAPI: HMAPIOperation<HMTexToSpeechAPIResponse> {
    init(text: String) {
        super.init(request: HMAPIRequest(name: "Text To Speech API",
                                         path: "tts/v1/rest/syn",
                                         method: .post,
                                         expandedHeaders: ["Content-Type": "application/json"],
                                         parameters: .raw(["text": text,
                                                           "voice": "doanngocle",
                                                           "id": "2",
                                                           "without_filter": false,
                                                           "speed": 1.0,
                                                           "tts_return_option": 2].json),
                                         enviroment: HMAPIMainEnvironment.viettelAI))
    }
}
struct HMTexToSpeechAPIResponse: HMAPIResponseProtocol {
    
    var messages: [String?]
    
    init(json: JSON) {
        // Parse json data from server to local variables
        messages = json[0]["result"]["hypotheses"].arrayValue.map({ $0["transcript_normed"].string })
    }
}
