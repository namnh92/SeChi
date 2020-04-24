//
//  HMRotationLabel.swift
//  TimXe
//
//  Created by NamNH-D1 on 5/9/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

@objc enum HMRotationDirection: Int {
    case degree0 = 0
    case degree90 = 1
    case degree180 = 2
    case degree270 = 3
}

@IBDesignable class HMRotationLabel: UILabel {

    @IBInspectable var insetTop: CGFloat = 5.0
    @IBInspectable var insetBottom: CGFloat = 5.0
    @IBInspectable var insetLeft: CGFloat = 7.0
    @IBInspectable var insetRight: CGFloat = 7.0
    @IBInspectable var direction: Int = 0
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var rotationAngle: CGFloat
        
        switch direction {
        case HMRotationDirection.degree0.rawValue:
            rotationAngle = 0
        case HMRotationDirection.degree90.rawValue:
            rotationAngle = CGFloat.pi / 2
        case HMRotationDirection.degree180.rawValue:
            rotationAngle = -CGFloat.pi / 2
        case HMRotationDirection.degree270.rawValue:
            rotationAngle = CGFloat.pi
        default:
            rotationAngle = 0
        }
        
        transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: insetTop, left: insetLeft, bottom: insetBottom, right: insetRight)
        super.drawText(in: rect.inset(by: insets))
    }
}
