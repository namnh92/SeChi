//
//  HMReminderVC.swift
//  HeyBeri
//
//  Created by NamNH on 4/24/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMReminderVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private var collapseSection: [Int] = [0]
    private var daysList: [String] = ["",""]
    private var reminderByDayList: [String] = ["","",""]
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setupView() {
        super.setupView()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.set(delegateAndDataSource: self)
        tableView.registerNibCellFor(type: HMReminderCell.self)
        tableView.registerNibCellFor(type: HMReminderCollapseCell.self)
    }
}

extension HMReminderVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return daysList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collapseSection.contains(section) {
            return reminderByDayList.count
        } else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.reusableCell(type: HMReminderCollapseCell.self) else { return UITableViewCell() }
            if collapseSection.contains(indexPath.section) {
                // Arrow up
            } else {
                // Arrow down
            }
            return cell
        } else {
            guard let cell = tableView.reusableCell(type: HMReminderCell.self) else { return UITableViewCell() }
            cell.delegate = self
            return cell
        }
    }
}

extension HMReminderVC: HMReminderCellDelegate {
    func swipeToComplete(at cell: HMReminderCell) {
        // Remove reminderByDayList
    }
    
    func swipeToDelete(at cell: HMReminderCell) {
        // Remove reminderByDayList
    }
}
