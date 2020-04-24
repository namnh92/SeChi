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
        tableView.separatorStyle = .none
        view.backgroundColor = UIColor(hex: "F0F4F8")
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 120, right: 0)
    }
}

extension HMReminderVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return reminderList.keys.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20.0))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRow = 1
        if collapseSection.contains(section) {
            let key = Array(reminderList.keys)[section]
            return numberOfRow + (reminderList[key]?.count ?? 0)
        } else { return numberOfRow }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.reusableCell(type: HMReminderCollapseCell.self) else { return UITableViewCell() }
            cell.setBorder(isBorder: collapseSection.contains(indexPath.section))
            return cell
        } else {
            guard let cell = tableView.reusableCell(type: HMReminderCell.self) else { return UITableViewCell() }
            let key = Array(reminderList.keys)[indexPath.section]
            cell.setBorder(isBorder: indexPath.row == reminderList[key]?.count)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if collapseSection.contains(indexPath.section) {
                if let index = collapseSection.firstIndex(of: indexPath.section) {
                    collapseSection.remove(at: index)
                    tableView.reloadSectionAt(index: indexPath.section)
                }
            } else {
                collapseSection.append(indexPath.section)
                tableView.reloadSectionAt(index: indexPath.section)
            }
        }
    }
}
