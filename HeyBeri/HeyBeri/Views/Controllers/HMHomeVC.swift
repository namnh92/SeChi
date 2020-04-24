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
    
    // MARK: - Constants
    private let pages: [HMBaseVC] = [HMReminderVC.create(), HMCalendarVC.create()]
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
    }
    
    private func setUpPageContainer() {
        if let firstVC = pages.first {
            pageContainer.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        pageContainer.view.frame = CGRect(x: 0, y: 0, width: HMSystemInfo.screenWidth, height: segmentedView.frame.height);
        addChild(pageContainer)
        segmentedView.addSubview(pageContainer.view)
    }

    @IBAction func invokeChangeTab(_ sender: UIButton) {
        if currentIndex == .reminder {
            currentIndex = .calendar
        } else {
            currentIndex = .reminder
        }
    }
}
