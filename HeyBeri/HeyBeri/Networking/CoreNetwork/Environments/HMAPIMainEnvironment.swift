//
//  HMAPIMainEnvironment.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 3/13/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HMAPIMainEnvironment: HMAPIEnvironmentProtocol {
    
    public var baseUrl: String = ""
    
    public var headers: HTTPHeaders = [:]
    
    public var encoding: ParameterEncoding = URLEncoding.default
    
    public var timeout: TimeInterval = 30
    
    class var `default`: HMAPIMainEnvironment {
        return HMAPIMainEnvironment(baseUrl: HMAPIConfiguration.baseUrl,
                                    headers: HMAPIConfiguration.httpHeaders,
                                    encoding: HMAPIConfiguration.encoding,
                                    timeout: HMAPIConfiguration.timeout)
    }
    
    class var chatBot: HMAPIMainEnvironment {
        return HMAPIMainEnvironment(baseUrl: HMAPIConfiguration.chatBotURL,
                                    headers: HMAPIConfiguration.httpChatBotHeaders,
                                    encoding: HMAPIConfiguration.encoding,
                                    timeout: HMAPIConfiguration.timeout)
    }
    
    class var speechToText: HMAPIMainEnvironment {
        return HMAPIMainEnvironment(baseUrl: HMAPIConfiguration.speechToTextURL,
                                    headers: HMAPIConfiguration.httpSpeechToTextHeader,
                                    encoding: HMAPIConfiguration.encoding,
                                    timeout: HMAPIConfiguration.timeout)
    }
    
    
    
    func parseApiErrorJson(_ json: JSON, statusCode: Int?) -> HMAPIError? {
        // Try to parse input json to error class according to your error json format
        // Example:
        guard let errorId = json["error_id"].int else { return nil }
        let errorMessage = json["error_message"].string
        return HMAPIError.api(statusCode: statusCode,
                              apiCode: errorId,
                              message: errorMessage)
    }
    
    // MARK: - Init
    init(baseUrl: String, headers: HTTPHeaders, encoding: ParameterEncoding, timeout: TimeInterval) {
        self.baseUrl = baseUrl
        self.headers = headers
        self.encoding = encoding
        self.timeout = timeout
    }
    
    // MARK: - Builder
    @discardableResult
    func set(baseUrl: String) -> HMAPIMainEnvironment {
        self.baseUrl = baseUrl
        return self
    }
    
    @discardableResult
    func set(headers: HTTPHeaders) -> HMAPIMainEnvironment {
        self.headers = headers
        return self
    }
    
    @discardableResult
    func set(encoding: ParameterEncoding) -> HMAPIMainEnvironment {
        self.encoding = encoding
        return self
    }
    
    @discardableResult
    func set(timeout: TimeInterval) -> HMAPIMainEnvironment {
        self.timeout = timeout
        return self
    }
}
