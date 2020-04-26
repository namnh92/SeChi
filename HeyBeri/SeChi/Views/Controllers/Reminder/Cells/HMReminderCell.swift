//
//  HMReminderCell.swift
//  HeyBeri
//
//  Created by Nguyễn Nam on 4/25/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMReminderCell: UITableViewCell {

    @IBOutlet weak var backView: HMShadowView!
    @IBOutlet weak var taskTimeLB: HMInsetLabel!
    @IBOutlet weak var taskDetailLB: UILabel!
    @IBOutlet weak var checkBoxButton: HMCheckBoxButton!
    
    var model: TaskReminder? {
        didSet {
            if let model = model {
                taskTimeLB.text = model.taskTime
                if model.typeTask == .completed {
                    taskDetailLB.strikeThrough(text: model.taskName)
                } else {
                    taskDetailLB.text = model.taskName
                }
                checkBoxButton.isChecked = model.typeTask == .completed
            }
        }
    }
    
    override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
        backgroundColor = .clear
    }

    func setBorder(isBorder: Bool) {
//        backView.cornerRadius = 5
//        backView.cornerTopLeft = false
//        backView.cornerTopRight = false
//        backView.cornerBottomLeft = isBorder
//        backView.cornerBottomRight = isBorder
    }
}
