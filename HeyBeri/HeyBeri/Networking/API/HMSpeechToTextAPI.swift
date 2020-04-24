//
//  HMSpeechToTextAPI.swift
//  AppStore
//
//  Created by NamNH on 4/23/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class HMSpeechToTextAPI: HMAPIOperation<HMSpeechToTextAPIResponse> {
    init(data: Data) {
        super.init(request: HMAPIRequest(name: "Speech To Text API",
                                       path: "",
                                       method: .post,
                                       parameters: .multiparts(parameters: [:], multiparts: [MultipartForm(data: data, name: "file", fileName: "speech_reg", mimeType: "wav")]),
                                       enviroment: HMAPIMainEnvironment.speechToText))
    }
}
struct HMSpeechToTextAPIResponse: HMAPIResponseProtocol {
    
    var messages: [String?]
    
    init(json: JSON) {
        // Parse json data from server to local variables
        messages = json[0]["result"]["hypotheses"].arrayValue.map({ $0["transcript_normed"].string })
    }
}
