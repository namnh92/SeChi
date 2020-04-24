//
//  UIViewController+Extension.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 3/13/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

protocol XibViewController {
    static var name: String { get }
    static func create() -> Self
}

extension XibViewController where Self: UIViewController {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func create() -> Self {
        return self.init(nibName: Self.name, bundle: nil)
    }
    
    static func present(from: UIViewController? = top(),
                        animated: Bool = true,
                        prepare: ((_ vc: Self) -> Void)? = nil,
                        completion: (() -> Void)? = nil) {
        guard let parentVC = from else { return }
        let targetVC = create()
        prepare?(targetVC)
        parentVC.present(targetVC, animated: animated, completion: completion)
    }
    
    static func push(from: UIViewController? = top(),
                     animated: Bool = true,
                     prepare: ((_ vc: Self) -> Void)? = nil,
                     completion: (() -> Void)? = nil) {
        guard let parentVC = from else { return }
        let targetVC = create()
        prepare?(targetVC)
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        parentVC.navigationController?.pushViewController(targetVC, animated: animated)
        CATransaction.commit()
    }
}

extension UIViewController: XibViewController { }

extension UIViewController {
    
    var name: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
    var isModal: Bool {
        if let navController = self.navigationController, navController.viewControllers.first != self {
            return false
        }
        if presentingViewController != nil {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    var isVisible: Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    class func top(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return top(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return top(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return top(controller: presented)
        }
        return controller
    }
    
    func dismissToRoot(controller: UIViewController? = UIViewController.top(),
                       animated: Bool = true,
                       completion: ((_ rootVC: UIViewController?) -> Void)? = nil) {
        guard let getController = controller else {
            completion?(nil)
            return
        }
        if let prevVC = getController.presentingViewController {
            if prevVC.isModal && prevVC.presentingViewController != nil {
                dismissToRoot(controller: prevVC, animated: animated, completion: completion)
            } else {
                getController.dismiss(animated: animated, completion: {
                    completion?(prevVC)
                })
            }
        } else {
            completion?(getController)
        }
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func pop(to: UIViewController, animated: Bool = true) {
        navigationController?.popToViewController(to, animated: animated)
    }
    
    func transition(toTab index: Int, completion:((_ nav: UINavigationController) -> Void)? = nil) {
        if isModal {
            self.dismissToRoot(completion: { rootVC in
                if let rootVC = rootVC,
                    let tabBarController: UITabBarController = rootVC as? UITabBarController,
                    let navBefore = tabBarController.selectedViewController as? UINavigationController {
                    navBefore.popToRootViewController(animated: false)
                    tabBarController.selectedIndex = index
                    if let navAfter = tabBarController.selectedViewController as? UINavigationController {
                        completion?(navAfter)
                    }
                }
            })
        } else {
            if tabBarController?.selectedIndex == index {
                popToRoot()
                if let nav = tabBarController?.selectedViewController as? UINavigationController {
                    completion?(nav)
                }
            } else {
                tabBarController?.selectedIndex = index
                if let nav = tabBarController?.selectedViewController as? UINavigationController {
                    completion?(nav)
                }
                popToRoot()
            }
        }
    }
}
