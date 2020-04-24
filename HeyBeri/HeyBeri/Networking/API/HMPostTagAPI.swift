//
//  HMPostTagAPI.swift
//  HeyBeri
//
//  Created by Nguyễn Nam on 4/25/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class HMPostTagAPI: HMAPIOperation<HMPostTagAPIResponse> {
    init(text: String) {
        super.init(request: HMAPIRequest(name: "Name Entity Recognition",
                                         path: "postag",
                                         method: .post,
                                         expandedHeaders: ["Content-Type": "application/json"],
                                         parameters: .raw(["sentence": text].json),
                                         enviroment: HMAPIMainEnvironment.viettelAINLP))
    }
}
struct HMPostTagAPIResponse: HMAPIResponseProtocol {
    
    var day: String?
    var action: String?
    
    init(json: JSON) {
        // Parse json data from server to local variables
        day = json["result"].arrayValue.map({ ($0["word"].string ?? "") }).filter({ $0.contains("ngày mai") || $0.contains("ngày kia") || $0.contains("hôm nay")}).first
        action = json["result"].arrayValue.map({ ($0["word"].string ?? "") }).filter({ $0.contains("đón") || $0.contains("gọi") || $0.contains("hẹn") || $0.contains("mua") || $0.contains("cách ly")}).first
    }
}
