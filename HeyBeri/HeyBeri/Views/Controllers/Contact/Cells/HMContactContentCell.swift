//
//  HMContactContentCell.swift
//  HeyBeri
//
//  Created by Nguyễn Nam on 4/25/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMContactContentCell: UITableViewCell {

    @IBOutlet weak var timeLB: HMInsetLabel!
    @IBOutlet weak var taskDetailLB: UILabel!
    @IBOutlet weak var checkBoxButton: HMCheckBoxButton!
    
    var model: TaskReminder? {
        didSet {
            if let model = model {
                timeLB.text = model.taskTime
                taskDetailLB.text = model.taskName
                if model.typeTask == .completed {
                    taskDetailLB.strikeThrough(text: model.taskName)
                } else {
                    taskDetailLB.text = model.taskName
                }
                checkBoxButton.isChecked = model.typeTask == .supportCompleted
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
