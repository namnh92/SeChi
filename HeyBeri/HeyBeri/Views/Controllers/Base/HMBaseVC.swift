//
//  HMBaseVC.swift
//  ProjectBase
//
//  Created by Nguyễn Nam on 4/8/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMBaseVC: UIViewController {
    
    //MARK: - Outlets
    //MARK: - Variables
    var titleString: String? {
        didSet {
            if let titleString = titleString {
                navigationItem.title = titleString
            }
        }
    }
    //MARK: - Constants
    //MARK: - Life cycles
    //MARK: - Setup views
    //MARK: - Actions
    //MARK: - Management datas
    //MARK: - Private methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    deinit {
        print("Deinit: \(name)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }

    //MARK: - Setup views
    func setupView() {
        baseConfig()
    }
    
    // MARK: - Public method
    
    // MARK: - Private method
    private func baseConfig() {
        
    }
    
    private func addBaseBackground() {
        
    }
    
    private func hideTabBar() {
        
    }
    
    private func hideNaviBar() {
        
    }
    
    private func addBackNavigationBarbutton() {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backButton = UIButton(frame: backView.frame)
        backButton.addTarget(self, action: #selector(invokeBackButton(_:)), for: .touchUpInside)
        
        let backImageView = UIImageView(frame: CGRect(x: 0, y: 13, width: 13, height: 14))
        backImageView.image = UIImage(named: "icon_back")
        backView.addSubview(backImageView)
        backView.addSubview(backButton)
        let backItem = UIBarButtonItem.init(customView: backView)
        
        navigationItem.leftBarButtonItems = [backItem]
    }
    
    // MARK: - Action
    @objc private func invokeBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
