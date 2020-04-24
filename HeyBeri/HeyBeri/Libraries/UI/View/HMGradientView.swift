//
//  HMGradientView.swift
//  ProjectBase
//
//  Created by Nguyễn Nam on 4/8/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

@IBDesignable class HMGradientView: UIView {
    
    // MARK: - Inspectable
    @IBInspectable var startColor: UIColor = .white
    @IBInspectable var endColor: UIColor = .white
    @IBInspectable var direction: Int = 0
    
    // MARK: - Variables
    var enableTapGesture: Bool = false {
        didSet { setupGestures() }
    }
    
    // MARK: - Closures
    var didTap: (() -> Void)?
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        clipsToBounds = true
        
        // Remove last gradient layer
        if let removeLayer = layer.sublayers?.filter({ $0 is HMGradientLayer }).first {
            removeLayer.removeFromSuperlayer()
        }
        
        // Add new gradient layer
        let newLayer = HMGradientLayer(startColor: startColor,
                                     endColor: endColor,
                                     direction: HMGradientDirection(rawValue: direction) ?? .leftToRight)
        newLayer.frame = bounds
        newLayer.borderWidth = borderWidth
        newLayer.borderColor = borderColor?.cgColor
        newLayer.cornerRadius = cornerRadius
        newLayer.masksToBounds = true
        layer.insertSublayer(newLayer, at: 0)
    }
    
    // MARK: - Data management
    func set(buttonBorderColor: UIColor, gradientStart: UIColor, gradientEnd: UIColor, gradientDirection: HMGradientDirection) {
        borderColor = buttonBorderColor
        startColor = gradientStart
        endColor = gradientEnd
        direction = gradientDirection.value
        setNeedsDisplay()
    }
    
    // MARK: - Action
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapGestureAction(sender: UITapGestureRecognizer) {
        didTap?()
    }
}
