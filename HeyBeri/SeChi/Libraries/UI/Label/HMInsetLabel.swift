//
//  HMInsetLabel.swift
//  TimXe
//
//  Created by Nguyễn Nam on 5/28/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMInsetLabel: UILabel {
    
    // MARK: - Inspectable
    @IBInspectable var insetTop: CGFloat = 5.0
    @IBInspectable var insetBottom: CGFloat = 5.0
    @IBInspectable var insetLeft: CGFloat = 7.0
    @IBInspectable var insetRight: CGFloat = 7.0
    
    // MARK: - UI
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: insetTop, left: insetLeft, bottom: insetBottom, right: insetRight)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += insetTop + insetBottom
        intrinsicSuperViewContentSize.width += insetLeft + insetRight
        return intrinsicSuperViewContentSize
    }
}
