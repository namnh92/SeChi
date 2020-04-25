//
//  HMNameEntityRecognitionAPI.swift
//  HeyBeri
//
//  Created by Nguyễn Nam on 4/25/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class HMNameEntityRecognitionAPI: HMAPIOperation<HMNameEntityRecognitionAPIResponse> {
    init(text: String) {
        super.init(request: HMAPIRequest(name: "Name Entity Recognition",
                                         path: "ner",
                                         method: .post,
                                         expandedHeaders: ["Content-Type": "application/json"],
                                         parameters: .raw(["sentence": text].json),
                                         enviroment: HMAPIMainEnvironment.viettelAINLP))
    }
}
struct HMNameEntityRecognitionAPIResponse: HMAPIResponseProtocol {
    
    var time: String?
    
    init(json: JSON) {
        // Parse json data from server to local variables
        time = json["result"].arrayValue.map({ ($0["word"].string ?? "") }).filter({ $0.contains("giờ")}).first
    }
}
