//
//  HMReminderCell.swift
//  HeyBeri
//
//  Created by NamNH on 4/24/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

protocol HMReminderCellDelegate: class {
    func swipeToComplete(at cell: HMReminderCell)
    func swipeToDelete(at cell: HMReminderCell)
}

class HMReminderCell: UITableViewCell {
    
    @IBOutlet weak var backView: HMShadowView!
    @IBOutlet weak var topView: UIView!
    
    weak var delegate: HMReminderCellDelegate?
    private var panGesture: UIPanGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeAction))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func swipeAction(_ recognizer: UIPanGestureRecognizer) {
        let topFrame = topView.frame
        let p: CGPoint = recognizer.translation(in: self)
        print("State: \(recognizer.state.rawValue)")
        switch recognizer.state {
        case .began:
            break
        case .changed:
            topView.frame = CGRect(x: p.x, y: topFrame.origin.y, width: topFrame.size.width, height: topFrame.size.height)
            if recognizer.velocity(in: self).x < 0 {
                backView.fillColor = .yellow
            } else {
                backView.fillColor = .blue
            }
        case .ended:
            print("State: \(recognizer.velocity(in: self).x)")
            if recognizer.velocity(in: self).x <
                -HMSystemInfo.screenWidth/2 {
                delegate?.swipeToDelete(at: self)
            } else if recognizer.velocity(in: self).x > HMSystemInfo.screenWidth/2 {
                delegate?.swipeToComplete(at: self)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.topView.frame = CGRect(x: 10, y: topFrame.origin.y, width: topFrame.size.width, height: topFrame.size.height)
                })
            }
        default:
            UIView.animate(withDuration: 0.2, animations: {
                self.topView.frame = CGRect(x: 10, y: topFrame.origin.y, width: topFrame.size.width, height: topFrame.size.height)
            })
        }
    }
}
