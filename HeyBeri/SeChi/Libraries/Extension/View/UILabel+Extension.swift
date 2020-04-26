//
//  UILabel+Extension.swift
//  ProjectBase
//
//  Created by NamNH-D1 on 4/9/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

extension UILabel {
    func strikeThrough(text: String) {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        attributedText = attributeString
    }
}
