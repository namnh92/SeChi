//
//  HMGradientButton.swift
//  ProjectBase
//
//  Created by Nguyễn Nam on 4/9/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

@IBDesignable class HMGradientButton: UIButton {
    
    // MARK: - Inspectable
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white
    @IBInspectable var direction: Int = 0
    
    @IBInspectable var cornerTopLeft: Bool = true
    @IBInspectable var cornerTopRight: Bool = true
    @IBInspectable var cornerBottomLeft: Bool = true
    @IBInspectable var cornerBottomRight: Bool = true
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Refresh clipping & masking
        clipsToBounds = true
        layer.masksToBounds = true
        
        // Remove last gradient layer
        if let removeLayer = layer.sublayers?.filter({ $0 is HMGradientLayer }).first {
            removeLayer.removeFromSuperlayer()
        }
        
        // Add new gradient layer
        let gradientLayer = HMGradientLayer(startColor: startColor,
                                          endColor: endColor,
                                          direction: HMGradientDirection(rawValue: direction) ?? .leftToRight)
        gradientLayer.frame = bounds
        
        // Create rounded path and shape layer for it
        var cornerList = UIRectCorner()
        if cornerTopLeft { cornerList.insert(.topLeft) }
        if cornerTopRight { cornerList.insert(.topRight) }
        if cornerBottomLeft { cornerList.insert(.bottomLeft) }
        if cornerBottomRight { cornerList.insert(.bottomRight) }
        let roundedRect = borderColor == .clear ? bounds : CGRect(x: borderWidth / 2, y: borderWidth / 2, width: rect.width - borderWidth, height: rect.height - borderWidth)
        let roundPath = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: cornerList, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        if !cornerTopLeft {
            roundPath.move(to: CGPoint(x: 0, y: borderWidth / 2))
            roundPath.addLine(to: CGPoint(x: borderWidth / 2, y: borderWidth / 2))
        }
        roundPath.lineWidth = borderWidth
        borderColor?.setStroke()
        roundPath.stroke()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = gradientLayer.bounds
        shapeLayer.path = roundPath.cgPath
        gradientLayer.mask = shapeLayer
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Builder
    func set(buttonBorderColor: UIColor, gradientStart: UIColor, gradientEnd: UIColor, gradientDirection: HMGradientDirection, cornerTopLeft: Bool, cornerTopRight: Bool, cornerBottomLeft: Bool, cornerBottomRight: Bool) {
        borderColor = buttonBorderColor
        startColor = gradientStart
        endColor = gradientEnd
        direction = gradientDirection.value
        self.cornerTopLeft = cornerTopLeft
        self.cornerTopRight = cornerTopRight
        self.cornerBottomLeft = cornerBottomLeft
        self.cornerBottomRight = cornerBottomRight
        setNeedsDisplay()
    }
    
    func setCornerRadius(_ value: CGFloat) {
        cornerRadius = value
        setNeedsDisplay()
    }
}
