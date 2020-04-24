//
//  HMIndicatorViewer.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 4/5/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import SVProgressHUD

class HMIndicatorViewer {
    static func show() {
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundLayerColor(UIColor.black.alpha(0.2))
        SVProgressHUD.show()
    }

    static func hide() {
        SVProgressHUD.dismiss()
    }
}
