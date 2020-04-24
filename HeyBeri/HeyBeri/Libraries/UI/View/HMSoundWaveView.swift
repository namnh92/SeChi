//
//  HMSoundWaveView.swift
//  AppStore
//
//  Created by NamNH on 4/23/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMSoundWaveView: HMCustomNibView {

    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Constants
    private let lineColor = UIColor(hex: 0xEF5050)
    private let lineWidth: CGFloat = 3
    private let distanceBetweenLines: CGFloat = 6
    private let maxDecibel: CGFloat = 40.0
    
    // MARK: - Variables
    
    // MARK: - Life cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        
    }
    
    // MARK: - Builder
    func add(decibelValue: CGFloat) {
        let decibel = -decibelValue
        let x = containerView.frame.width
        let y = (containerView.frame.height / 2 * decibel / maxDecibel)
        let width = lineWidth
        let height = containerView.frame.height - (y * 2)
        let lineView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        lineView.layer.cornerRadius = width / 2
        lineView.backgroundColor = lineColor
        containerView.addSubview(lineView)
        updatePositionAllLines()
    }
    
    // MARK: - Update UI
    private func updatePositionAllLines() {
        for line in containerView.subviews {
            line.frame.origin.x -= lineWidth + distanceBetweenLines
            if line.frame.origin.x <= -lineWidth {
                line.removeFromSuperview()
            }
        }
    }
}
