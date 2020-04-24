//
//  HMNoCursorTextField.swift
//  TimXe
//
//  Created by AnhLT3-D1 on 5/30/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMNoCursorTextField: UITextField {
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
