//
//  HMCustomNibView.swift
//  AppStore
//
//  Created by NamNH on 4/23/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit

class HMCustomNibView: UIView {

    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        guard let xibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last else { return }
        Bundle(for: type(of: self)).loadNibNamed(xibName, owner: self, options: nil)
        frame.size = contentView.frame.size
        addSubview(contentView)
        contentView.fixInView(self)
        backgroundColor = .clear
    }
}
