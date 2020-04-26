//
//  UIView+Extension.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 3/13/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

protocol XibView {
    static var name: String { get }
    static func createFromXib() -> Self
}

extension XibView where Self: UIView {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func createFromXib() -> Self {
        return Self.init()
    }
}

extension UIView: XibView { }

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func fixInView(_ container: UIView!) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
// MARK: - Extension for Inspectable
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set(value) {
            clipsToBounds = true
            layer.cornerRadius = value
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: borderColor)
        }
        set(value) {
            layer.borderColor = value?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(value) {
            layer.borderWidth = value
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set(value) {
            layer.shadowOffset = value
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set(value) {
            layer.shadowRadius = value
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set(value) {
            layer.shadowOpacity = value
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: layer.shadowColor ?? UIColor.clear.cgColor)
        }
        set(value) {
            layer.shadowColor = value.cgColor
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set(value) {
            layer.masksToBounds = value
        }
    }
}

// MARK: - Extension for all
extension UIView {
    // MARK: - Variables
    var name: String {
        return type(of: self).name
    }
    
    var subviewsRecursive: [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive }
    }
    
    var parentViewController: UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.parentViewController
        } else {
            return nil
        }
    }
    
    var globalPointWithEntireScreen: CGPoint? {
        return superview?.convert(frame.origin, to: nil)
    }
    
    var globalFrameWithEntireScreen: CGRect? {
        return superview?.convert(frame, to: nil)
    }
    
    // MARK: - Local functions
    
    func set(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
    }
    
    func set(borderWidth: CGFloat, withColor color: UIColor) {
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
    }
    
    func set(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        set(cornerRadius: cornerRadius)
        set(borderWidth: borderWidth, withColor: borderColor)
    }
    
    func setShadow(color: UIColor, opacity: Float, offSet: CGSize, radius: CGFloat) {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
    
    func setGradientBackground(startColor: UIColor, endColor: UIColor, gradientDirection: HMGradientDirection) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = gradientDirection.draw().x
        gradientLayer.endPoint = gradientDirection.draw().y
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// Extension for cutting & masking layers
extension UIView {
    func cut(rect: CGRect) {
        let p:CGMutablePath = CGMutablePath()
        p.addRect(bounds)
        p.addRect(rect)
        
        let s = CAShapeLayer()
        s.path = p
        s.fillRule = CAShapeLayerFillRule.evenOdd
        
        self.layer.mask = s
    }
    
    func cut(path: CGPath) {
        let p:CGMutablePath = CGMutablePath()
        p.addRect(bounds)
        p.addPath(path)
        
        let s = CAShapeLayer()
        s.path = p
        s.fillRule = CAShapeLayerFillRule.evenOdd
        
        layer.mask = s
    }
}


