//
//  HMRangeSlider.swift
//  SeChi
//
//  Created by NamNH-D1 on 8/19/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMRangeSlider: UIControl {
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    private var minimumValue: CGFloat = 0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    private var maximumValue: CGFloat = 1 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var lowerValue: CGFloat = 0.2 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var gapValue: CGFloat = 0.1 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var upperValue: CGFloat = 0.8 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var valueRange: CGFloat = 1 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var lowerValueText: String = "" {
        didSet {
            lowerLabel.text = lowerValueText
            updateLayerFrames()
        }
    }
    
    var upperValueText: String = "" {
        didSet {
            upperLabel.text = upperValueText
            updateLayerFrames()
        }
    }
    
    var valueTextFont: UIFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            lowerLabel.font = valueTextFont
            upperLabel.font = valueTextFont
            updateLayerFrames()
        }
    }
    var valueTextColor: UIColor = .black {
        didSet {
            lowerLabel.textColor = valueTextColor
            upperLabel.textColor = valueTextColor
            updateLayerFrames()
        }
    }
    
    var trackHeight: CGFloat = 3.0 {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var trackTintColor: UIColor = UIColor.gray {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var trackHighlightTintColor: UIColor = UIColor.blue {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var thumbImage: UIImage? {
        didSet {
            if let thumbImage = thumbImage {
                upperThumbImageView.image = thumbImage
                lowerThumbImageView.image = thumbImage
                updateLayerFrames()
            }
        }
    }
    
    var highlightedThumbImage: UIImage? {
        didSet {
            if let highlightedThumbImage = highlightedThumbImage {
                upperThumbImageView.highlightedImage = highlightedThumbImage
                lowerThumbImageView.highlightedImage = highlightedThumbImage
                updateLayerFrames()
            }
        }
    }
    
    private let trackLayer = RangeSliderTrackLayer()
    private let lowerThumbImageView = UIImageView()
    private let upperThumbImageView = UIImageView()
    private let lowerLabel = UILabel()
    private let upperLabel = UILabel()
    private var previousLocation = CGPoint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumbImageView.image = thumbImage
        addSubview(lowerThumbImageView)
        lowerLabel.text = "\(lowerValue)"
        lowerLabel.textAlignment = .center
        addSubview(lowerLabel)
        
        upperThumbImageView.image = thumbImage
        addSubview(upperThumbImageView)
        upperLabel.text = "\(upperValue)"
        upperLabel.textAlignment = .center
        addSubview(upperLabel)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 1
    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        guard let thumbImage = thumbImage else { return }
        lowerThumbImageView.frame = CGRect(origin: thumbOriginForValue(lowerValue),
                                           size: thumbImage.size)
        let maxSize = CGSize(width: 60, height: 16)
        let lowerSize = lowerLabel.sizeThatFits(maxSize)
        lowerLabel.frame = CGRect(x: lowerThumbImageView.center.x - lowerSize.width/2.0, y: lowerThumbImageView.frame.height + 6.0, width: lowerSize.width, height: lowerSize.height)
        
        upperThumbImageView.frame = CGRect(origin: thumbOriginForValue(upperValue),
                                           size: thumbImage.size)
        let upperSize = upperLabel.sizeThatFits(maxSize)
        upperLabel.frame = CGRect(x: upperThumbImageView.center.x - upperSize.width/2.0, y: upperThumbImageView.frame.height + 6.0, width: upperSize.width, height: upperSize.height)
        
        CATransaction.commit()
    }
    // 2
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return frame.width * value
    }
    // 3
    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        guard let thumbImage = thumbImage else { return CGPoint(x: 0, y: 0) }
        let x = positionForValue(value) - thumbImage.size.width/2
        return CGPoint(x: x, y: (bounds.height - thumbImage.size.height) / 2.0)
    }
}

extension HMRangeSlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // 1
        previousLocation = touch.location(in: self)
        
        // 2
        if lowerThumbImageView.frame.contains(previousLocation) {
            lowerThumbImageView.isHighlighted = true
        } else if upperThumbImageView.frame.contains(previousLocation) {
            upperThumbImageView.isHighlighted = true
        }
        
        // 3
        return lowerThumbImageView.isHighlighted || upperThumbImageView.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        // 1
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width
        
        previousLocation = location
        
        // 2
        if lowerThumbImageView.isHighlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue,
                                    upperValue: upperValue, isLower: true)
        } else if upperThumbImageView.isHighlighted {
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue,
                                    upperValue: maximumValue, isLower: false)
        }
        
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbImageView.isHighlighted = false
        upperThumbImageView.isHighlighted = false
    }
    
    // 4
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat, isLower: Bool) -> CGFloat {
        return min(max(value, lowerValue + (isLower ? 0.0 : gapValue)), upperValue - (isLower ? gapValue : 0.0))
    }
}

class RangeSliderTrackLayer: CALayer {
    weak var rangeSlider: HMRangeSlider?
    
    override func draw(in ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0.0, y: (bounds.height - slider.trackHeight)/2.0,width: bounds.width,
            height: slider.trackHeight), cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        
        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.fillPath()
        
        ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
        let lowerValuePosition = slider.positionForValue(slider.lowerValue)
        let upperValuePosition = slider.positionForValue(slider.upperValue)
        let rect = CGRect(x: lowerValuePosition, y: (bounds.height - slider.trackHeight)/2.0,
                          width: upperValuePosition - lowerValuePosition,
                          height: slider.trackHeight)
        ctx.fill(rect)
    }
}
