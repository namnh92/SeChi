//
//  HMReminderVC.swift
//  HeyBeri
//
//  Created by NamNH on 4/24/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit
import RealmSwift

class HMReminderVC: HMBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private var collapseSection: [Int] = []
    private var reminderList: [String:[TaskReminder]] = [:] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
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
    
    private func getData() {
        let listTaskReminder = HMRealmService.instance.load(listOf: TaskReminder.self).filter({ $0.supporter == nil })
        reminderList = Dictionary(grouping: listTaskReminder, by: { $0.taskDay })
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
            cell.taskDate = Array(reminderList.keys)[indexPath.section]
            let key = Array(reminderList.keys)[indexPath.section]
            if let reminderListByDate = reminderList[key] {
                cell.numberTask = "\(reminderListByDate.count)"
            } else {
                cell.numberTask = "0"
            }
            return cell
        } else {
            guard let cell = tableView.reusableCell(type: HMReminderCell.self) else { return UITableViewCell() }
            let key = Array(reminderList.keys)[indexPath.section]
            if let reminderListByDate = reminderList[key] {
                cell.setBorder(isBorder: indexPath.row == reminderListByDate.count)
                cell.model = reminderListByDate[indexPath.row - 1]
                return cell
            } else { return UITableViewCell() }
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
