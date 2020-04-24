//
//  HMSlider.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 7/23/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMSlider: UISlider {
    
    // MARK: - Inspectable
    @IBInspectable var thumbImage: UIImage? = nil {
        didSet {
            if let thumbImage = thumbImage {
                setThumbImage(thumbImage, for: .normal)
            }
        }
    }
    
    @IBInspectable var trackHeight: CGFloat = 3.0
   
    // MARK: - UI
    override func draw(_ rect: CGRect) {
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(x: 0, y: (frame.size.height - trackHeight)/2, width: frame.size.width, height: trackHeight)
    }
}
