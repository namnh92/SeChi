//
//  HMRootTabBarController.swift
//  HeyBeri
//
//  Created by NamNH on 4/22/20.
//  Copyright © 2020 NamNH. All rights reserved.
//

import UIKit

enum TabBarItem : Int {
    case home = 0
    case category = 1
    case scanQr = 2
    case history = 3
    case account = 4
    
    static let tabBarItems = [home : "Trang chủ",
                              category : "Danh mục",
                              scanQr : nil,
                              history : "Lịch sử",
                              account: "Tài khoản"]
    
    func getTabBarItems() -> String? {
        return TabBarItem.tabBarItems[self] ?? nil
    }
    
    static let tabBarImages = [home : "icon_home",
                               category : "icon_category",
                               scanQr : "icon_scanQr",
                               history : "icon_history",
                               account: "icon_account"]
    
    func getTabBarImages() -> String {
        return TabBarItem.tabBarImages[self] ?? ""
    }
}

class HMRootTabBarController: UITabBarController {

    static let instance = HMRootTabBarController()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    // MARK: - Private func
    private func setupView() {
        tabBar.tintColor = UIColor(hex: "#BC2026")
        tabBar.unselectedItemTintColor = UIColor(hex: "#676767")
        viewControllers = [navController(HMChatBotVC(), tab: .home),
                           navController(UIViewController(), tab: .category),
                           navController(UIViewController(), tab: .scanQr),
                           navController(UIViewController(), tab: .history),
                           navController(UIViewController(), tab: .account)]
    }
    
    private func navController(_ rootVC :UIViewController, tab: TabBarItem) -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        switch tab {
        case .scanQr:
            navigationVC.tabBarItem.title = tab.getTabBarItems()
            navigationVC.tabBarItem.image = UIImage(named: tab.getTabBarImages())?.withRenderingMode(.alwaysOriginal)
            navigationVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        default:
            navigationVC.tabBarItem.title = tab.getTabBarItems()
            navigationVC.tabBarItem.image = UIImage(named: tab.getTabBarImages())
        }
        return navigationVC
    }
    
}
