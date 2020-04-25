//
//  HMHomeVC.swift
//  HeyBeri
//
//  Created by NamNH on 4/24/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

enum MenuItem: Int {
    case reminder = 0
    case calendar = 1
}

class HMHomeVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var segmentedView: UIView!
    @IBOutlet weak var reminderIndicatorView: HMGradientView!
    @IBOutlet weak var calendarIndicatorView: HMGradientView!
    @IBOutlet weak var addReminderButton: UIButton!
    
    // MARK: - Constants
    private let pages: [HMBaseVC] = [HMReminderVC.create(), HMContactVC.create()]
    private let pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    // MARK: - Variables
    private var currentIndex: MenuItem? {
        didSet {
            if let currentIndex = currentIndex {
                reminderIndicatorView.isHidden = currentIndex == .reminder ? false : true
                calendarIndicatorView.isHidden = !reminderIndicatorView.isHidden
                let direction: UIPageViewController.NavigationDirection = currentIndex == .calendar ? .forward : .reverse
                pageContainer.setViewControllers([pages[currentIndex.rawValue]], direction: direction, animated: true, completion: nil)
            }
        }
    }
    var time: String?
    var date: String?
    var action: String?
    
    // MARK: - Life cycles
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        HMOneSignalNotificationService.shared.sendPush()
//    }

    override func setupView() {
        super.setupView()
        
        setUpPageContainer()
        reminderIndicatorView.isHidden = true
        calendarIndicatorView.isHidden = true
        currentIndex = .reminder
        addLeftNavigationBarbutton()
        addRightNavigationBarbutton()
    }
    
    private func setUpPageContainer() {
        if let firstVC = pages.first {
            pageContainer.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        pageContainer.view.frame = CGRect(x: 0, y: 0, width: HMSystemInfo.screenWidth, height: segmentedView.frame.height);
        addChild(pageContainer)
        segmentedView.addSubview(pageContainer.view)
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
    
//    split message and take the action word only
    private func takeActionFromWord(msg: String) -> String {
        let words_list = ["đón", "đi", "mua", "lau", "quét"]
        var job = ""
        for word in words_list {
            if msg.contains(word) {
                job = "\(word)\(msg.components(separatedBy: word)[1])"
            }
        }
    return job
        
    }
    
    @objc private func invokeMenuButton(_ sender: UIButton) {
        
    }
    
    @objc private func invokeNotifyButton(_ sender: UIButton) {
        
    }
    
    @IBAction func invokeChangeTab(_ sender: UIButton) {
        currentIndex = MenuItem(rawValue: sender.tag)
    }
    
    @IBAction func invokeAddReminder(_ sender: UIButton) {
        let addReminderVC = HMAddReminderVC.create()
        addReminderVC.didAddReminder = { [weak self] message in
            guard let sSelf = self else { return }
            let group = DispatchGroup()
            group.enter()
            HMNameEntityRecognitionAPI(text: message ?? "").execute(target: sSelf, success: { [weak self] (response) in
                self?.time = response.time
                group.leave()
            }) { (error) in
                group.leave()
            }
            
            group.enter()
            HMPostTagAPI(text: message ?? "").execute(target: sSelf, success: { [weak self] (response) in
                self?.date = response.day
                self?.action = response.action
                group.leave()
            }) { (error) in
                group.leave()
            }
            
            group.notify(queue: .main) {
                // Do Add DB
                HMRealmService.instance.write { [weak self] (realm) in
                    let task = TaskReminder()
                    task.id = TaskReminder.incrementID()
                    task.taskName = self!.takeActionFromWord(msg: message ?? "").replace(string: task.taskTime, with: "").replace(string: task.taskDay, with: "")
                    task.taskDay = self?.date ?? ""
                    task.taskTime = self?.time ?? ""
                    task.typeTask = .notCompleted
                    realm.add(task, update: .all)
                }
            }
            
        }
        addReminderVC.modalPresentationStyle = .overCurrentContext
        let transition = CATransition()
        transition.duration = 0.5
        transition.subtype = CATransitionSubtype.fromTop
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(addReminderVC, animated: true, completion: nil)
    }
}
