//
//  HMContactHeaderCell.swift
//  HeyBeri
//
//  Created by Nguyễn Nam on 4/25/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMContactHeaderCell: UITableViewCell {

    @IBOutlet weak var contactNameLB: UILabel!
    
    var model: HMContactModel? {
        didSet {
            contactNameLB.text = model?.name
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
