//
//  HMContactVC.swift
//  HeyBeri
//
//  Created by Nguyễn Nam on 4/25/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMContactVC: HMBaseVC {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    
    // MARK: - Consants
    private let contactNames = ["Chồng Béo", "Chị Ti <3", "Người phụ nữ vĩ đại", "Bố ơi giúp con với"]
    // MARK: - Variables
    private var collapseSection: [Int] = []
    private var listContact: [HMContactModel] = [] {
        didSet {
            for contact in listContact {
                reminderList[contact.name] = getData(by: contact)
            }
        }
    }
    private var reminderList: [String:[TaskReminder]] = [:] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        for contactName in contactNames {
            HMRealmService.instance.write { (realm) in
                let contact = HMContactModel()
                contact.id = HMContactModel.incrementID()
                contact.name = contactName
                realm.add(contact, update: .all)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getContact()
    }
    
    override func setupView() {
        super.setupView()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.set(delegateAndDataSource: self)
        tableView.tableHeaderView = tableHeaderView
        tableView.registerNibCellFor(type: HMContactHeaderCell.self)
        tableView.registerNibCellFor(type: HMContactContentCell.self)
        tableView.separatorStyle = .none
        view.backgroundColor = UIColor(hex: "F0F4F8")
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 120, right: 0)
    }
    
    private func getContact() {
        listContact = HMRealmService.instance.load(listOf: HMContactModel.self)
    }
    
    private func getData(by contact: HMContactModel) -> [TaskReminder] {
        return HMRealmService.instance.load(listOf: TaskReminder.self).filter({ $0.supporter == contact })
    }
}

extension HMContactVC: UITableViewDataSource, UITableViewDelegate {
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
            guard let cell = tableView.reusableCell(type: HMContactHeaderCell.self) else { return UITableViewCell() }
            cell.model = listContact[indexPath.section]
            return cell
        } else {
            guard let cell = tableView.reusableCell(type: HMContactContentCell.self) else { return UITableViewCell() }
            let key = Array(reminderList.keys)[indexPath.section]
            cell.model = reminderList[key]?[indexPath.row]
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
