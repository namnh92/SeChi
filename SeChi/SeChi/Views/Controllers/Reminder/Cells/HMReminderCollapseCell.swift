//
//  HMReminderCollapseCell.swift
//  SeChi
//
//  Created by Nguyễn Nam on 4/25/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMReminderCollapseCell: UITableViewCell {

    @IBOutlet weak var backView: HMCornerView!
    @IBOutlet weak var taskDateLB: UILabel!
    @IBOutlet weak var numberTaskLB: HMInsetLabel!
    
    var taskDate: String? {
        didSet {
            taskDateLB.text = taskDate
        }
    }
    var numberTask: String? {
        didSet {
            numberTaskLB.text = numberTask
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
    }

    func setBorder(isBorder: Bool) {
//        backView.cornerRadius = 5
//        backView.cornerTopLeft = true
//        backView.cornerTopRight = true
//        backView.cornerBottomLeft = false
//        backView.cornerBottomRight = false
    }
    
}
