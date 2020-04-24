//
//  HMAPIRequest.swift
//  Develop
//
//  Created by NamNH-D1 on 3/14/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public struct MultipartForm {
    let data: Data
    let name: String
    let fileName: String
    let mimeType: String
}

public enum HMAPIParameterType {
    case body(_ parameters: Parameters)
    case raw(_ text: String)
    case multiparts(parameters: Parameters, multiparts: [MultipartForm]?)
    case binary(_ data: Data)
}

// Request
public struct HMAPIRequest {
    var enviroment: HMAPIMainEnvironment
    var name: String
    var path: String
    var method: HTTPMethod
    var expandedHeaders: HTTPHeaders
    var parameters: HMAPIParameterType
    
    var asFullUrl: String {
        return enviroment.baseUrl + (!path.isEmpty ? "/" : "") + path
    }
    
    var asFullHttpHeaders: HTTPHeaders {
        var fullHeaders: HTTPHeaders = [:]
        enviroment.headers.forEach {
            fullHeaders[$0.name] = $0.value
        }
        expandedHeaders.forEach {
            fullHeaders[$0.name] = $0.value
        }
        return fullHeaders
    }
    
    init(name: String,
         path: String,
         method: HTTPMethod,
         expandedHeaders: HTTPHeaders = [:],
         parameters: HMAPIParameterType,
         enviroment: HMAPIMainEnvironment = HMAPIMainEnvironment.default) {
        self.name = name
        self.path = path
        self.method = method
        self.expandedHeaders = expandedHeaders
        self.parameters = parameters
        self.enviroment = enviroment
    }
    
    func printInformation() {
        print("\n[Request API] ▶︎ [\(name)]")
        print("▶︎ Full url: \(asFullUrl)")
        print("▶︎ Method: \(method.rawValue)")
        print("▶︎ HTTP Headers:\n\(JSON(asFullHttpHeaders))")
        switch parameters {
        case .body(let params):
            print("▶︎ Parameters:\n\(JSON(params))")
        case .raw(let text):
            print("▶︎ Raw text:\n\(text)")
        case .multiparts(let params, let multiparts):
            print("▶︎ Parameters:\n\(JSON(params))")
            print("▶︎ Multiparts:\n\(multiparts)")
        case .binary(let data):
            print("▶︎ Data length: \(data.count)\n")
        }
    }
}
