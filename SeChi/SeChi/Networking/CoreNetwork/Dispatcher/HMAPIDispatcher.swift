//
//  HMAPIDispatcher.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 4/5/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

import UIKit
import Alamofire
import SwiftyJSON

public protocol HMAPIDispatcherProtocol {
    // Execute the request
    func execute(request: HMAPIRequest, completed: @escaping ((_ json: HMAPIResponse) -> Void))
    func prepareBodyFor(request: HMAPIRequest) -> URLRequestConvertible
    func prepareRawFor(request: HMAPIRequest, rawText: String) -> URLRequest?
    func prepareHeadersForMultipartOrBinary(request: HMAPIRequest) -> HTTPHeaders
    func cancel()
}

class HMAPIDispatcher: HMAPIDispatcherProtocol {
    // Singleton variable for using default network enviroment
    //static var shared = NetworkDispatcher(enviroment: APIEnviroment.default)
    
    // MARK: - Variables
    weak var target: UIViewController?
    private var request: HMAPIRequest?
    private var completionHandler: ((_ response: HMAPIResponse) -> Void)?
    
    // MARK: - Init & deinit
    init() {
        HMAPIProcessingManager.instance.add(dispatcher: self)
    }
    
    // MARK: - Request API task
    private var dataRequest: DataRequest?
    private var uploadRequest: UploadRequest?
    
    func execute(request: HMAPIRequest, completed: @escaping ((_ response: HMAPIResponse) -> Void)) {
        self.request = request
        self.completionHandler = completed
        // Check case of request's parameters
        switch request.parameters {
        case .body:
            let urlRequest = prepareBodyFor(request: request)
            self.dataRequest = AF.request(urlRequest).responseJSON(completionHandler: { [weak self] data in
                guard let sSelf = self else { return }
                completed(HMAPIResponse(data, fromRequest: request))
                HMAPIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                print("▶︎ [API Processing Manager] Removed body request from list for screen: \(sSelf.target?.name ?? "none") !")
            })
        case .raw(let text):
            guard let rawRequest = prepareRawFor(request: request, rawText: text) else {
                completed(HMAPIResponse.error(HMAPIError.unknown))
                return
            }
            self.dataRequest = AF.request(rawRequest).responseJSON(completionHandler: { [weak self] data in
                guard let sSelf = self else { return }
                completed(HMAPIResponse(data, fromRequest: request))
                HMAPIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                print("▶︎ [API Processing Manager] Removed raw request from list for screen: \(sSelf.target?.name ?? "none") !")
            })
        case .multiparts(let parameters, let multiparts):
            let fullHttpHeaders = prepareHeadersForMultipartOrBinary(request: request)
            self.uploadRequest = AF.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    if let valueData = "\(value)".data(using: String.Encoding.utf8) {
                        multipartFormData.append(valueData, withName: key as String)
                    }
                }
                if let multiparts = multiparts {
                    for multipart in multiparts {
                        multipartFormData.append(multipart.data, withName: multipart.name, fileName: multipart.fileName, mimeType: multipart.mimeType)
                    }
                }
            }, to: request.asFullUrl, method: request.method, headers: fullHttpHeaders).responseJSON { [weak self] data in
                guard let sSelf = self else { return }
                completed(HMAPIResponse(data, fromRequest: request))
                HMAPIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                print("▶︎ [API Processing Manager] Removed multipart request from list for screen: \(sSelf.target?.name ?? "none") !")
            }.uploadProgress { progress in
                completed(HMAPIResponse.progress(progress.fractionCompleted))
            }
        case .binary( let data):
            let fullHttpHeaders = prepareHeadersForMultipartOrBinary(request: request)
            self.uploadRequest = AF.upload(data, to: request.asFullUrl, method: request.method, headers: fullHttpHeaders).responseJSON { [weak self] response in
                guard let sSelf = self else { return }
                completed(HMAPIResponse(response, fromRequest: request))
                HMAPIProcessingManager.instance.removeDispatcherFromList(dispatcher: sSelf)
                print("▶︎ [API Processing Manager] Removed binary request from list for screen: \(sSelf.target?.name ?? "none") !")
            }
        }
    }
    
    // MARK: - Retry api task
    func retry() {
        guard let request = self.request, let completionHandler = self.completionHandler else { return }
        execute(request: request, completed: completionHandler)
    }
    
    // MARK: - Cancel api task
    func cancel() {
        if let dataRequest = self.dataRequest {
            dataRequest.cancel()
            self.dataRequest = nil
        }
        if let uploadRequest = self.uploadRequest {
            uploadRequest.cancel()
            self.uploadRequest = nil
        }
        HMAPIProcessingManager.instance.removeDispatcherFromList(dispatcher: self)
    }
}

// MARK: - Prepare input data for requests
extension HMAPIDispatcher {
    func prepareBodyFor(request: HMAPIRequest) -> URLRequestConvertible {
        return ConvertibleRequest(request: request)
    }
    
    func prepareRawFor(request: HMAPIRequest, rawText: String) -> URLRequest? {
        // Request url
        let enviroment = request.enviroment
        guard let url = URL(string: request.asFullUrl) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        
        // Method
        urlRequest.httpMethod = request.method.rawValue
        
        // Timeout interval
        urlRequest.timeoutInterval = enviroment.timeout
        
        // Http headers
        request.asFullHttpHeaders.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.name)
        }
        
        // Raw text
        guard let textData = rawText.data(using: .utf8, allowLossyConversion: false) else { return nil }
        urlRequest.httpBody = textData
        
        // Return result
        return urlRequest
    }
    
    func prepareHeadersForMultipartOrBinary(request: HMAPIRequest) -> HTTPHeaders {
        return request.asFullHttpHeaders
    }
}

struct ConvertibleRequest: URLRequestConvertible {
    
    private var request: HMAPIRequest
    
    init(request: HMAPIRequest) {
        self.request = request
    }
    
    func asURLRequest() throws -> URLRequest {
        // Request url
        let enviroment = request.enviroment
        var urlRequest = URLRequest(url: URL(string: request.asFullUrl)!)
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        
        // Method
        urlRequest.httpMethod = request.method.rawValue
        
        // Timeout interval
        urlRequest.timeoutInterval = enviroment.timeout
        
        // Http headers
        request.asFullHttpHeaders.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.name)
        }
        
        // Parameters
        var parameters: Parameters = [:]
        switch request.parameters {
        case .body(let params):
            parameters = params
        default:
            break
        }
        
        // Return result
        return try enviroment.encoding.encode(urlRequest, with: parameters)
    }
}
