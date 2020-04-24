//
//  HMAPIOperation.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 4/5/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

protocol HMAPIOperationProtocol {
    // Request
    var request: HMAPIRequest? { set get }
}

class HMAPIOperation<T: HMAPIResponseProtocol>: HMAPIOperationProtocol {
    
    // MARK: - Typealias
    typealias Output = T
    typealias DataResponseSuccess = (_ result: Output) -> Void
    typealias DataResponseError = (_ error: HMAPIError) -> Void
    typealias ErrorDialogResponse = (() -> Void)
    typealias OfflineDialogResponse = ((_ tapRetry: Bool) -> Void)
    
    // MARK: - Constants
    struct TaskData {
        var responseQueue: DispatchQueue = .main
        var showIndicator: Bool = true
        var autoShowApiErrorAlert = true
        var autoShowRequestErrorAlert = true
        var didCloseApiErrorDialogHandler: ErrorDialogResponse? = nil
        var didCloseRequestErrorDialogHandler: ErrorDialogResponse? = nil
        var didCloseOfflineDialogHandler: OfflineDialogResponse? = nil
        var successHandler: DataResponseSuccess? = nil
        var failureHandler: DataResponseError? = nil
        init() { }
    }
    
    // MARK: - Variables
    private var taskData = TaskData()
    private var dispatcher: HMAPIDispatcher?
    
    var request: HMAPIRequest?
    
    // MARK: - Init & deinit
    init(request: HMAPIRequest?) {
        self.request = request
        dispatcher = HMAPIDispatcher()
    }
    
    // MARK: - Builder (public)
    @discardableResult
    func set(responseQueue: DispatchQueue) -> HMAPIOperation<Output> {
        taskData.responseQueue = responseQueue
        return self
    }
    
    @discardableResult
    // Load request without: showing indicator + showing api error alert + request error alert automatically
    func set(silentLoad: Bool) -> HMAPIOperation<Output> {
        taskData.showIndicator = !silentLoad
        taskData.autoShowApiErrorAlert = !silentLoad
        taskData.autoShowRequestErrorAlert = !silentLoad
        return self
    }
    
    @discardableResult
    func showIndicator(_ show: Bool) -> HMAPIOperation<Output> {
        taskData.showIndicator = show
        return self
    }
    
    @discardableResult
    func autoShowApiErrorAlert(_ show: Bool) -> HMAPIOperation<Output> {
        taskData.autoShowApiErrorAlert = show
        return self
    }
    
    @discardableResult
    func autoShowRequestErrorAlert(_ show: Bool) -> HMAPIOperation<Output> {
        taskData.autoShowRequestErrorAlert = show
        return self
    }
    
    @discardableResult
    func didCloseApiErrorDialog(_ handler: @escaping ErrorDialogResponse) -> HMAPIOperation<Output> {
        taskData.didCloseApiErrorDialogHandler = handler
        return self
    }
    
    @discardableResult
    func didCloseRequestErrorDialog(_ handler: @escaping ErrorDialogResponse) -> HMAPIOperation<Output> {
        taskData.didCloseRequestErrorDialogHandler = handler
        return self
    }
    
    @discardableResult
    func didCloseOfflineErrorDialog(_ handler: @escaping OfflineDialogResponse) -> HMAPIOperation<Output> {
        taskData.didCloseOfflineDialogHandler = handler
        return self
    }
    
    // MARK: - Executing functions (public)
    @discardableResult
    func execute(target: UIViewController?, progressClosure:((Int)-> Void?)? = nil , success: DataResponseSuccess? = nil, failure: DataResponseError? = nil) -> HMAPIOperation<Output> {
        func run(queue: DispatchQueue?, body: @escaping () -> Void) {
            (queue ?? .main).async {
                body()
            }
        }
        dispatcher?.target = target
        taskData.successHandler = success
        taskData.failureHandler = failure
        let showIndicator = taskData.showIndicator
        let responseQueue = taskData.responseQueue
        if let request = self.request {
            if showIndicator {
                run(queue: .main) { HMAPIUIIndicator.showIndicator() }
            }
            // Print information of request
            request.printInformation()
            print("▶︎ [\(request.name)] is requesting...")
            
            // Execute request
            dispatcher?.execute(request: request, completed: { response in
                switch response {
                case .success(let json):
                    print("▶︎ [\(request.name)] succeed !")
                    run(queue: responseQueue) {
                        self.callbackSuccess(output: T(json: json))
                    }
                case .error(let error):
                    print("▶︎ [\(request.name)] error message: \"\(error.message ?? "empty")\"")
                    run(queue: responseQueue) {
                        self.callbackError(error: error)
                    }
                case .progress((let progress)):
                    print("▶︎ [\(request.name)] progress: \"\(progress)\"")
                    run(queue: responseQueue) {
                        guard let progressClosure = progressClosure else { return }
                        progressClosure(Int(progress*100))
                    }
                }
            })
        } else {
            run(queue: responseQueue) {
                self.callbackError(error: HMAPIError.unknown)
            }
        }
        return self
    }
    
    func cancel() {
        dispatcher?.cancel()
    }
    
    // MARK: - Handle callback with input data
    private func callbackSuccess(output: T) {
        taskData.successHandler?(output)
        if taskData.showIndicator {
            DispatchQueue.main.async { HMAPIUIIndicator.hideIndicator() }
        }
    }
    
    private func callbackError(error: HMAPIError) {
        DispatchQueue.main.async {
            self.showErrorAlertIfNeeded(error: error)
        }
        taskData.failureHandler?(error)
        if taskData.showIndicator {
            DispatchQueue.main.async { HMAPIUIIndicator.hideIndicator() }
        }
    }
    
    // MARK: - Alerts
    private func showErrorAlertIfNeeded(error: HMAPIError) {
        switch error {
        case .api:
            guard taskData.autoShowApiErrorAlert else { return }
            HMAPIUIAlert.showApiErrorDialogWith(error: error, completion: {
                self.taskData.didCloseApiErrorDialogHandler?()
            })
            
        case .request(_, let requestError):
            guard taskData.autoShowRequestErrorAlert, let requestError = requestError else { return }
            if requestError.isInternetOffline {
                HMAPIUIAlert.showOfflineErrorDialog(completion: { index, tapRetry in
                    if tapRetry {
                        self.execute(target: self.dispatcher?.target,
                                     success: self.taskData.successHandler,
                                     failure: self.taskData.failureHandler)
                    }
                })
            } else {
                HMAPIUIAlert.showRequestErrorDialogWith(error: error, completion: {
                    self.taskData.didCloseRequestErrorDialogHandler?()
                })
            }
        }
    }
}
