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
    private var reminderList: [String:[String]] = ["Ngày 1": ["Việc 1","Việc 2"],
                                                   "Ngày 2": ["Việc 3","Việc 4"]]
    
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
        return reminderList.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        if collapseSection.contains(section) {
            let key = Array(reminderList.keys)[section]
            return numberOfRow + (reminderList[key]?.count ?? 0)
        } else { return numberOfRow }
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
        if let index = tableView.indexPath(for: cell) {
            let key = Array(reminderList.keys)[index.section]
            reminderList[key]?.remove(at: index.row - 1)
            tableView.reloadSectionAt(index: index.section)
        }
    }
    
    func swipeToDelete(at cell: HMReminderCell) {
        // Remove reminderByDayList
        if let index = tableView.indexPath(for: cell) {
            let key = Array(reminderList.keys)[index.section]
            reminderList[key]?.remove(at: index.row - 1)
            tableView.reloadSectionAt(index: index.section)
        }
    }
}
