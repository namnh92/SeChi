//
//  HMAPIEnvironmentProtocol.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 3/13/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public protocol HMAPIEnvironmentProtocol {
    // MARK: - Variable interfaces
    var baseUrl: String { get }
    var headers: HTTPHeaders { get }
    var encoding: ParameterEncoding { get }
    var timeout: TimeInterval { get }
    
    // MARK: - Function interfaces
    func parseApiErrorJson(_ json: JSON, statusCode: Int?) -> HMAPIError?
}
