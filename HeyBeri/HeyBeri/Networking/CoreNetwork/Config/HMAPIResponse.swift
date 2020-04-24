//
//  HMAPIResponse.swift
//  Develop
//
//  Created by NamNH-D1 on 3/14/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

// Define response data types for each request
public enum HMAPIResponse {
    case success(_: JSON)
    case error(_: HMAPIError)
    case progress(_: Double)
    
    init(_ response: DataResponse<Any, AFError>, fromRequest request: HMAPIRequest) {
        // Get status code
        let statusCode = response.response?.statusCode
        
        // Check if the request error exists
        if let error = response.error {
            self = .error(HMAPIError.request(statusCode: statusCode, error: error))
            return
        }
        
        // Check if response has data or not
        guard let jsonData = response.value else {
            self = .error(HMAPIError.request(statusCode: statusCode, error: response.error))
            return
        }
        
        // Try to parse api error if possible
        let json: JSON = JSON(jsonData)
        if let error = request.enviroment.parseApiErrorJson(json, statusCode: statusCode) {
            self = .error(error)
            return
        }
        
        // Get data successfully
        self = .success(json)
    }
}

// Model repsonse protocol based on JSON data (View Controller's layers are able to view this protocol as response data)
public protocol HMAPIResponseProtocol {
    // Set json as input variable
    init(json: JSON)
}
