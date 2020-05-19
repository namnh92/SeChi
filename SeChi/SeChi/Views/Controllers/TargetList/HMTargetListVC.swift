//
//  HMTargetListVC.swift
//  SeChi
//
//  Created by NamNH on 5/19/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

struct Target {
    let task: String
    let name: String
    let count: String
    let color : UIColor
}

class HMTargetListVC: HMBaseVC {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var homeVC: HMHomeVC?
    private var collapseSection: [Int] = []
    private var targets: [Target] = [
        Target(task: "Đọc sách cho con", name: "@Chồng béo", count: "2/5\nTháng này", color: UIColor(hex: "A4B3FF")),
        Target(task: "Thăm bố mẹ", name: "@Chị Ti", count: "1/2\nTháng này", color: UIColor(hex: "FF92B2")),
        Target(task: "Đi bộ", name: "@Chồng béo", count: "4/8\nTháng này", color: UIColor(hex: "A4B3FF")),
        Target(task: "Đi chùa", name: "@Người phụ nữ vĩ đại", count: "0/1\nTháng này", color: UIColor(hex: "79D4C8"))]
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupView() {
        super.setupView()
        setupTableView()
        addLeftNavigationBarbutton()
        addRightNavigationBarbutton()
    }
    
    private func addLeftNavigationBarbutton() {
        let menuView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let menuButton = UIButton(frame: menuView.frame)
        menuButton.addTarget(self, action: #selector(invokeMenuButton(_:)), for: .touchUpInside)
        
        let menuImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 19, height: 16))
        menuImageView.image = UIImage(named: "icon_menu")
        menuView.addSubview(menuImageView)
        menuView.addSubview(menuButton)
        let menuItem = UIBarButtonItem.init(customView: menuView)
        
        navigationItem.leftBarButtonItems = [menuItem]
    }
    
    private func addRightNavigationBarbutton() {
        let notifyView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let notifyButton = UIButton(frame: notifyView.frame)
        notifyButton.addTarget(self, action: #selector(invokeNotifyButton(_:)), for: .touchUpInside)
        
        let notifyImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 18, height: 21))
        notifyImageView.image = UIImage(named: "icon_notify")
        notifyView.addSubview(notifyImageView)
        notifyView.addSubview(notifyButton)
        let notifyItem = UIBarButtonItem.init(customView: notifyView)
        
        navigationItem.rightBarButtonItems = [notifyItem]
    }
    
    private func setupTableView() {
        tableView.set(delegateAndDataSource: self)
        tableView.registerNibCellFor(type: HMTargetCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 120, right: 0)
    }
    
    // MARK: - Actions
    @objc private func invokeMenuButton(_ sender: UIButton) {
        
    }
    
    @objc private func invokeNotifyButton(_ sender: UIButton) {
        
    }
    
    @IBAction func invokeTargetButton(_ sender: UIButton) {
        dismissToRoot(animated: false)
    }
    
    @IBAction func invokeAddReminder(_ sender: UIButton) {
        dismiss(animated: false) { [weak self] in
            self?.homeVC?.invokeAddReminder(sender)
        }
    }
}

extension HMTargetListVC: UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targets.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.reusableCell(type: HMTargetCell.self) else { return UITableViewCell() }
        cell.setupCell(target: targets[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
