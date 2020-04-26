//
//  HMCircularProgressView.swift
//  TimXe
//
//  Created by NamNH-D1 on 5/15/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

@IBDesignable
class HMCircularProgressView: UIView {

    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var tracklayer = CAShapeLayer()
    
    @IBInspectable var progressColor:UIColor = UIColor.red {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    @IBInspectable var progressWidth:CGFloat = 2.0
    
    @IBInspectable var trackColor:UIColor = UIColor.white {
        didSet {
            tracklayer.strokeColor = trackColor.cgColor
        }
    }
    
    @IBInspectable var trackWidth:CGFloat = 2.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        createCircularPath()
    }
    
    fileprivate func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2.0
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
                                      radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * Double.pi),
                                      endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
        
        tracklayer.path = circlePath.cgPath
        tracklayer.fillColor = UIColor.clear.cgColor
        tracklayer.strokeColor = trackColor.cgColor
        tracklayer.lineWidth = progressWidth;
        tracklayer.strokeEnd = 1.0
        layer.addSublayer(tracklayer)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = trackWidth;
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
        
    }
    
    func showProgress() {
        if (progressLayer.animationKeys()?.contains("animateCircle") ?? false) {
            return
        }
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.5
        // Animate from 0 (no circle) to 1 (full circle)
        animation.repeatCount = .infinity
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = CGFloat(1)
        progressLayer.add(animation, forKey: "animateCircle")
    }
    
    func hideProgress() {
        progressLayer.removeAllAnimations()
    }
}
