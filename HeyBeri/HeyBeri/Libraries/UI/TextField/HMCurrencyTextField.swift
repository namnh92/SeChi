//
//  HMCurrencyTextField.swift
//  TimXe
//
//  Created by Nguyễn Nam on 5/25/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit

@IBDesignable
class HMCurrencyTextField: UITextField {
    
    // MARK: - Inspectable
    @IBInspectable var insetTop: CGFloat = 0
    @IBInspectable var insetLeft: CGFloat = 10
    @IBInspectable var insetBottom: CGFloat = 0
    @IBInspectable var insetRight: CGFloat = 10
    @IBInspectable var currencySymbol: String = "JPY"
    
    // MARK: - Variables
    private var insets: UIEdgeInsets {
        return UIEdgeInsets(top: insetTop, left: insetLeft, bottom: insetBottom, right: insetRight)
    }
    var string: String { return text ?? "" }
    var decimal: Decimal {
        return string.decimal /
            pow(10, Formatter.currency().maximumFractionDigits)
    }
    var decimalNumber: NSDecimalNumber { return decimal.number }
    var doubleValue: Double { return decimalNumber.doubleValue }
    var integerValue: Int { return decimalNumber.intValue   }
    let maximum: Decimal = 999_999_999.99
    private var lastValue: String?
    
    // MARK: - Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        // you can make it a fixed locale currency if needed
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        keyboardType = .numberPad
        textAlignment = .left
        editingChanged(self)
    }
    
    override func deleteBackward() {
        text = String(string.digits.dropLast())
        editingChanged(self)
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        guard decimal <= maximum else {
            text = lastValue
            return
        }

        text = Formatter.currency().string(for: decimal)?.replace(string: "¥", with: currencySymbol)
        lastValue = text
    }
}

extension NumberFormatter {
    convenience init(numberStyle: Style, locale: Locale) {
        self.init()
        self.numberStyle = numberStyle
        self.locale = locale
        self.maximumFractionDigits = 0
        self.minimumFractionDigits = 0
    }
}

extension Formatter {
    static func currency() -> NumberFormatter {
        let currency = NumberFormatter()
        currency.numberStyle = .currency
        currency.currencySymbol = "JPY"
        currency.decimalSeparator = ","
        currency.maximumFractionDigits = 0
        currency.minimumFractionDigits = 0
        return currency
    }
}

extension String {
    var digits: String { return filter(("0"..."9").contains) }
    var decimal: Decimal { return Decimal(string: digits) ?? 0 }
}

extension Decimal {
    var number: NSDecimalNumber { return NSDecimalNumber(decimal: self) }
}
