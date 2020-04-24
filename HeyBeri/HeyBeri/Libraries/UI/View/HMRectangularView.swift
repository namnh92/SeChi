//
//  HMRectangularView.swift
//  ProjectBase
//
//  Created by Nguyễn Nam on 4/8/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

@objc enum HMArrowDirection: Int {
    case up = 0
    case down = 1
    case left = 2
    case right = 3
}

@IBDesignable class HMRectangularView: UIView {
    
    // MARK: - IBInspectables
    @IBInspectable var direction: Int = 0
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var pointMove = CGPoint()
        var pointStartOne = CGPoint()
        var pointStartTwo = CGPoint()
        switch direction {
        case HMArrowDirection.up.rawValue:
            pointMove = CGPoint(x: self.frame.width/2, y: 0.0)
            pointStartOne = CGPoint(x: 0.0, y: self.frame.height)
            pointStartTwo = CGPoint(x: self.frame.width, y: self.frame.height)
        case HMArrowDirection.down.rawValue:
            pointMove = CGPoint(x: self.frame.width/2, y: self.frame.height)
            pointStartOne = CGPoint(x: 0.0, y: 0.0)
            pointStartTwo = CGPoint(x: self.frame.size.width, y: 0.0)
        case HMArrowDirection.left.rawValue:
            pointMove = CGPoint(x: 0.0, y: self.frame.size.height/2)
            pointStartOne = CGPoint(x: self.frame.width, y: 0.0)
            pointStartTwo = CGPoint(x: self.frame.width, y: self.frame.height)
        case HMArrowDirection.right.rawValue:
            pointMove = CGPoint(x: self.frame.width, y: self.frame.size.height/2)
            pointStartOne = CGPoint(x: 0.0, y: 0.0)
            pointStartTwo = CGPoint(x: 0.0, y: self.frame.height)
        default:
            pointMove = CGPoint(x: self.frame.width/2, y: 0.0)
            pointStartOne = CGPoint(x: 0.0, y: self.frame.height)
            pointStartTwo = CGPoint(x: self.frame.width, y: self.frame.height)
        }
        
        let path = UIBezierPath()
        path.move(to: pointMove)
        path.addLine(to: pointStartOne)
        path.addLine(to: pointStartTwo)
        path.close()
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
