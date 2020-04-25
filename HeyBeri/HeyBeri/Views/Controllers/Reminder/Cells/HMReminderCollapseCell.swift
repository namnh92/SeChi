//
//  HMReminderCollapseCell.swift
//  HeyBeri
//
//  Created by Nguyễn Nam on 4/25/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMReminderCollapseCell: UITableViewCell {

    @IBOutlet weak var backView: HMCornerView!
    
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
