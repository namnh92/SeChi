//
//  HMAPIError.swift
//  Develop
//
//  Created by NamNH-D1 on 3/14/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Alamofire

public enum HMAPIError {
    case api(statusCode: Int?, apiCode: Int?, message: String?)
    case request(statusCode: Int?, error: Error?)
    
    var apiCode: Int? {
        switch self {
        case .api(_, let apiCode, _):
            return apiCode
        default:
            return nil
        }
    }
    
    var statusCode: Int? {
        switch self {
        case .api(let statusCode, _, _):
            return statusCode
        case .request(let statusCode, _):
            return statusCode
        }
    }
    
    var message: String? {
        switch self {
        case .api(_, _, let message):
            return message
        case .request(_, let error):
            guard let error = error else {
                return "Lỗi không xác định"
            }
            if error.isInternetOffline || error.isNetworkConnectionLost || error.isHostConnectFailed {
                return "Không có kết nối Internet"
            } else if error.isTimeout {
                return "Quá thời gian kết nối tới máy chủ"
            } else if error.isBadServerResponse {
                return "Không có dữ liệu từ máy chủ"
            } else {
                return "Không thể kết nối đến máy chủ"
            }
        }
    }
    
    // Create an unknown api error
    static var unknown: HMAPIError {
        return HMAPIError.request(statusCode: nil, error: nil)
    }
}

// MARK: - Extension Error

extension Error {
    var errorCode: Int? {
        return (self as NSError).code
    }
    
    var urlCode: URLError.Code? {
        return (self as? URLError)?.code
    }
    
    var isUnknown: Bool {
        return urlCode  == .unknown
    }
    
    var isTimeout: Bool {
        return urlCode == .timedOut
    }
    
    var isHostNotFound: Bool {
        return urlCode == .cannotFindHost
    }
    
    var isHostConnectFailed: Bool {
        return urlCode == .cannotConnectToHost
    }
    
    var isNetworkConnectionLost: Bool {
        return urlCode == .networkConnectionLost
    }
    
    var isInternetOffline: Bool {
        return urlCode  == .notConnectedToInternet
    }
    
    var isBadServerResponse: Bool {
        return urlCode == .badServerResponse
    }
}
