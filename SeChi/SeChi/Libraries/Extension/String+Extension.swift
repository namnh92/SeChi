//
//  String+Extension.swift
//  TimXe
//
//  Created by NamNH-D1 on 5/17/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import CommonCrypto
//import SwiftyRSA

// General enum list
enum RandomStringType: String {
    case numericDigits = "0123456789"
    case uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case lowercaseLetters = "abcdefghijklmnopqrstuvwxyz"
    case allKindLetters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    case numericDigitsAndLetters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    var text: String { return rawValue }
}

extension String {
    var int: Int? {
        return Int(self)
    }
    
    var float: Float? {
        return Float(self)
    }
    
    var url: URL? {
        return URL(string: self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    
    var image: UIImage? {
        return UIImage(named: self)
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    var percentEncoding: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    var trimNewLines: String {
        return self.trimmingCharacters(in: .newlines)
    }
    
    var md5: String? {
        guard let messageData = self.data(using:.utf8) else { return nil }
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    //    var encryptAES: String? {
    //        let key = "mwLZH3hyy6jKR0AP"
    //        let iv = "FWmn6Yu5KXPUKZrp"
    //        do {
    //            if let data = self.data(using: .utf8) {
    //                let encrypted = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7).encrypt([UInt8](data))
    //                let encryptedString = Data(encrypted).base64EncodedString()
    //                return encryptedString
    //            }
    //        } catch { }
    //        return nil
    //    }
    
    //    var decryptAES: String? {
    //        let key = "mwLZH3hyy6jKR0AP"
    //        let iv = "FWmn6Yu5KXPUKZrp"
    //        do {
    //            if let data = Data(base64Encoded: self) {
    //                let decrypted = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7).decrypt([UInt8](data))
    //                let decryptedString = String(bytes: Data(decrypted).bytes, encoding: .utf8)
    //                return decryptedString
    //            }
    //        } catch { }
    //        return nil
    //    }
    
    var hasSpecialCharacters: Bool {
        let regex = "(?=.*[A-Za-z0-9]).{8,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    var isEmail: Bool {
        let regex = "^(([\\w+-]+\\.)+[\\w+-]+|([a-zA-Z+]{1}|[\\w+-]{2,}))@((([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])){1}|([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        if self.contains("-") || self.contains("*") || self.contains("+") {
            let precidate = NSPredicate(format: "SELF MATCHES %@", "^((\\+)|(00))[0-9]{6,14}$")
            return precidate.evaluate(with: self)
        }
        let precidate = NSPredicate(format: "SELF MATCHES %@", "([0-9]){10,11}$")
        return precidate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        if self.getBytesBy(encoding: HMSystemInfo.shiftJISEncoding) != self.count { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Za-z0-9]).{8,}")
        return passwordTest.evaluate(with: self)
    }
    
    var isFullSizeCharacter: Bool {
        return getBytesBy(encoding: HMSystemInfo.shiftJISEncoding) == 2
    }
    
    var isLocationInJapan: Bool {
        let regex = "^.{0,3}"
        if let range = self.range(of: regex, options: .regularExpression) {
            let result = String(describing: [range])
            if result == "080" || result == "090" {
                return true
            }
        }
        return false
    }
    
    static func randomStringWith(type: RandomStringType, length: Int) -> String {
        let letters: NSString = type.text as NSString
        let len = UInt32(letters.length)
        var randomString = ""
        (0..<length).forEach { _ in
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    static func add(separatorText text: String = ",", to number: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = text
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: number))
    }
    
    func numberBy(removing separator: String) -> Int {
        let seperatedArr = components(separatedBy: separator)
        var finalNumber = 0
        for (i, numStr) in seperatedArr.reversed().enumerated() {
            if let dNum = Int(numStr) {
                finalNumber += dNum * Int(pow(10, Double(i)))
            }
        }
        return finalNumber
    }
    
    func phoneTrimming() -> String {
        return self.components(separatedBy:CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    func dateBy(format: String, calendar: Calendar, timeZone: TimeZone?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: self)
    }
    
    func textBounds(width: CGFloat, font: UIFont) -> CGRect {
        let st = self as NSString
        return st.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                               options: .usesLineFragmentOrigin,
                               attributes: [.font: font],
                               context: nil)
    }
    
    func textBounds(height: CGFloat, font: UIFont) -> CGRect {
        let st = self as NSString
        return st.boundingRect(with: CGSize(width: CGFloat(CGFloat.greatestFiniteMagnitude), height: height),
                               options: .usesLineFragmentOrigin,
                               attributes: [.font: font],
                               context: nil)
    }
    
    func replace(string: String, with newString: String) -> String {
        return self.replacingOccurrences(of: string, with: newString)
    }
    
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func height(withWidth width: CGFloat, font: UIFont, paragraphType: NSParagraphStyle) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font,
                                                         .paragraphStyle: paragraphType],
                                            context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func startIndex(of subString: String) -> Int? {
        if let range = self.range(of: subString) {
            return distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func endIndex(of subString: String) -> Int? {
        if let range = self.range(of: subString, options: .backwards) {
            return distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func getBytesBy(encoding: String.Encoding) -> Int? {
        return data(using: encoding)?.count
    }
    
    func changeTimeShortFormat() -> String {
        guard let date = self.dateBy(format: "HH:mm:ss", calendar: Date.currentCalendar, timeZone: Date.currentTimeZone)
            else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func dateByLocale(_ identifier: String, format: String ) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: identifier)
        dateFormatter.dateFormat = format
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.calendar = Date.currentCalendar
        dateFormatter.timeZone = Date.currentTimeZone
        return dateFormatter.date(from: self)
    }
    
    func changeDateShortFormat() -> String {
        let date = self.dateBy(format: "YYYY-MM-dd", calendar: Calendar.current, timeZone: TimeZone.current)
        let string = "\(date?.day ?? 0) \(date?.monthForVietnamese ?? "")"
        return string
    }
    
//    func decrypt() -> String? {
//        do {
//            let privateKey = try PrivateKey(pemEncoded: Constants.privateKey)
//            let encrypted = try EncryptedMessage(base64Encoded: self)
//            let clear = try encrypted.decrypted(with: privateKey, padding: .OAEP)
//            
//            // Then you can use:
//            let string = try clear.string(encoding: .utf8)
//            return string
//        } catch {
//            print("Decrypted error ---\(error.localizedDescription)")
//        }
//        return nil
//    }
}

// MARK: - Handle Emojis
extension String {
    var glyphCount: Int {
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        return glyphCount == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        return unicodeScalars.contains { $0.isEmoji }
    }
    
    var containsOnlyEmoji: Bool {
        return !isEmpty && !unicodeScalars.contains(where: {
            !$0.isEmoji && !$0.isZeroWidthJoiner
        })
    }
    
    var emojiString: String {
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        for scalar in emojiScalars {
            if let prev = previousScalar, !prev.isZeroWidthJoiner && !scalar.isZeroWidthJoiner {
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            previousScalar = scalar
        }
        scalars.append(currentScalarSet)
        return scalars.map { $0.map { String($0) } .reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            if let previous = previous, previous.isZeroWidthJoiner && cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
            } else if cur.isEmoji {
                chars.append(cur)
            }
            previous = cur
        }
        return chars
    }
}

// MARK: - Other extension
extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
extension UnicodeScalar {
    var isEmoji: Bool {
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        65024...65039, // Variation selector
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        return value == 8205
    }
}

// Caltulate width and height of text in label
extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width + 25)
    }
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}


extension String {
    
    /// Inner comparison utility to handle same versions with different length. (Ex: "1.0.0" & "1.0")
    private func compare(toVersion targetVersion: String) -> ComparisonResult {
        
        let versionDelimiter = "."
        var result: ComparisonResult = .orderedSame
        var versionComponents = components(separatedBy: versionDelimiter)
        var targetComponents = targetVersion.components(separatedBy: versionDelimiter)
        let spareCount = versionComponents.count - targetComponents.count
        
        if spareCount == 0 {
            result = compare(targetVersion, options: .numeric)
        } else {
            let spareZeros = repeatElement("0", count: abs(spareCount))
            if spareCount > 0 {
                targetComponents.append(contentsOf: spareZeros)
            } else {
                versionComponents.append(contentsOf: spareZeros)
            }
            result = versionComponents.joined(separator: versionDelimiter)
                .compare(targetComponents.joined(separator: versionDelimiter), options: .numeric)
        }
        return result
    }
    
    public func isVersion(equalTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedSame }
    public func isVersion(greaterThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedDescending }
    public func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedAscending }
    public func isVersion(lessThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedAscending }
    public func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedDescending }
}
