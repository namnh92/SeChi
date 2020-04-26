//
//  UISearchBar+Extension.swift
//  TimXe
//
//  Created by NamNH-D1 on 6/4/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

public extension UISearchBar {
    
    func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    
}
