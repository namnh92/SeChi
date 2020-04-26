//
//  HMAPIUIAlert.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 4/5/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

// MARK: - Init list of dialogs
class HMAPIUIAlert {
    static func apiErrorDialog(error: HMAPIError, completion: @escaping (() -> Void)) -> UIAlertController {
        // Write your code to show your api error dialog, call completion when done
        // Example:
        let alertVC = UIAlertController(title: nil, message: error.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            completion()
        }))
        return alertVC
    }
    
    static func requestErrorDialog(error: HMAPIError, completion: @escaping (() -> Void)) -> UIAlertController {
        // Write your code to show your api error dialog, call completion when done
        // Example:
        let alertVC = UIAlertController(title: nil, message: error.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            completion()
        }))
        return alertVC
    }
    
    static func offlineErrorDialog(completion: @escaping ((_ index: Int, _ tapRetry: Bool) -> Void)) -> UIAlertController {
        let title = "Lỗi kết nối"
        let message = "Không có kết nối Internet, vui lòng thử lại."
        let buttons = ["Thử lại", "Đóng"]
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        buttons.enumerated().forEach { button in
            let action = UIAlertAction(title: button.element, style: .default, handler: { _ in
                completion(button.offset, button.offset == 0)
            })
            alertVC.addAction(action)
        }
        return alertVC
    }
}

// MARK: - Presenting functions
extension HMAPIUIAlert {
    static func showApiErrorDialogWith(error: HMAPIError, completion: @escaping (() -> Void)) {
        let alert = HMAPIUIAlert.apiErrorDialog(error: error, completion: completion)
        UIViewController.top()?.present(alert, animated: true)
    }
    
    static func showRequestErrorDialogWith(error: HMAPIError, completion: @escaping (() -> Void)) {
        let alert = HMAPIUIAlert.requestErrorDialog(error: error, completion: completion)
        UIViewController.top()?.present(alert, animated: true)
    }
    
    static func showOfflineErrorDialog(completion: @escaping ((_ index: Int, _ tapRetry: Bool) -> Void)) {
        let alert = HMAPIUIAlert.offlineErrorDialog(completion: completion)
        UIViewController.top()?.present(alert, animated: true)
    }
}
