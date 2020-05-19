//
//  HMTargetCell.swift
//  SeChi
//
//  Created by Nguyễn Nam on 5/19/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMTargetCell: UITableViewCell {
    
    @IBOutlet weak var taskLB: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var countLB: UILabel!
    @IBOutlet weak var dateView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
    }

    func setupCell(target: Target) {
        taskLB.text = target.task
        nameLB.text = target.name
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: target.count)
        attributeString.addAttributes([NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 36.0)], range: NSMakeRange(0, 1))
        attributeString.addAttributes([NSAttributedString.Key.font: UIFont(name: "Roboto-Bold", size: 24.0)], range: NSMakeRange(1, 2))
//        attributeString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15.0)], range: NSMakeRange(2, attributeString.length))
        
        countLB.attributedText = attributeString
        dateView.backgroundColor = target.color
        
    }
    
}
