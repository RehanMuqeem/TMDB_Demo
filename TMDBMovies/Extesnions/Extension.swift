//
//  String+Extension.swift
//  TMDBMovies
//
//  Created by appinventiv on 26/12/22.
//

import UIKit

//MARK: - Extension String
extension String {
    
    func stringByRemovingEmoji() -> String {
        return String(self.filter { !$0.isEmoji() })
    }
    
    func isContainEmoji() -> Bool {
        let isContain = self.first(where: { $0.isEmoji() }) != nil
        return isContain
    }
    
    func containsSpecialCharacters() -> Bool {
        let capitalLetterRegEx = ".*[!&^%$#?@()/*;:'`]+.*"
        let textTest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        return textTest.evaluate(with: self)
    }
    
    func toDateText(inputDateFormat: Date.DateFormat = .yyyy_MM_dd, outputDateFormat: Date.DateFormat = .ddMMMyyyy, timeZone: TimeZone = TimeZone.current) -> String {
        if let date = self.toDate(dateFormat: inputDateFormat.rawValue, timeZone: timeZone) {
            return date.toString(dateFormat: outputDateFormat.rawValue, timeZone: timeZone)
        } else {
            return ""
        }
    }
    
    ///Converts the string into 'Date' if possible, based on the given date format and timezone. otherwise returns nil
    func toDate(dateFormat: String, timeZone: TimeZone = TimeZone.current) -> Date? {
        let frmtr = DateFormatter()
        frmtr.locale = Locale(identifier: "en_US_UNIX")
        frmtr.dateFormat = dateFormat
        frmtr.timeZone = timeZone
        return frmtr.date(from: self)
    }
    
    func toDate(_ dateFormat: Date.DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        let date = dateFormatter.date(from: self)
        return date
    }
    
}

//MARK: - Extension Date
extension Date {
    
    enum DateFormat : String {
        case yyyy_MM_dd = "yyyy-MM-dd"
        case ddMMMyyyy = "dd MMM yyyy"
    }
    
    ///Converts a given Date into String based on the date format and timezone provided
    func toString(dateFormat: String, timeZone: TimeZone = TimeZone.current) -> String {
        let frmtr = DateFormatter()
       // frmtr.locale = Locale(identifier: SelectedChannel.shared.channelID.languageId())
        frmtr.dateFormat = dateFormat
        frmtr.timeZone = timeZone
        return frmtr.string(from: self)
    }
    
    func toString(dateFormat: DateFormat, timeZone: TimeZone = TimeZone.current) -> String {
        let frmtr = DateFormatter()
       // frmtr.locale = Locale(identifier: SelectedChannel.shared.channelID.languageId())
        frmtr.dateFormat = dateFormat.rawValue
        frmtr.timeZone = timeZone
        return frmtr.string(from: self)
    }
    
}

//MARK: - Extension Int
extension Int {
    
    var minutesToHoursAndMinutes: String {
        return "\(self / 60)h" + " \(self % 60)m"
    }
    
}

//MARK: - Extension Double
extension Double {
    /// Rounds the double to decimal places value
//    func rounded(toPlaces places:Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return floor(self * divisor) / divisor
//    }
    
    
    func round(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return ((self * divisor).rounded())/divisor
    }
    
}

//MARK: - Extension Character
extension Character {
    
    func isContainsEmoji() -> Bool {
        return Character(UnicodeScalar(UInt32(0x1d000))!) <= self && self <= Character(UnicodeScalar(UInt32(0x1f77f))!)
            || Character(UnicodeScalar(UInt32(0x2100))!) <= self && self <= Character(UnicodeScalar(UInt32(0x26ff))!)
    }
    
    func isEmoji() -> Bool {
        switch self.unicodeScalarCodePoint() {
            case 0x1F600...0x1F64F, // Emoticons
                0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                0x1F680...0x1F6FF, // Transport and Map
                0x1F1E6...0x1F1FF, // Regional country flags
                0x2600...0x26FF,   // Misc symbols 9728 - 9983
                0x2700...0x27BF,   // Dingbats
                0xFE00...0xFE0F,   // Variation Selectors
                0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs 129280 - 129535
                0x1F018...0x1F270, // Various asian characters           127000...127600
                65024...65039, // Variation selector
                9100...9300, // Misc items
                8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default: return false
        }
    }
    
    private func unicodeScalarCodePoint() -> UInt32 {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        return scalars[scalars.startIndex].value
    }
    
}

//MARK: - Extension UIView
extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func roundParticularCorners(_ radius: CGFloat, _ corners: CACornerMask) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = corners
        } else {
            // Fallback on earlier versions
        }
    }
    
    /// adds shadow in the view
    public func addShadow(ofColor color: UIColor = #colorLiteral(red: 0.01568627451, green: 0.01960784314, blue: 0.09803921569, alpha: 0.5), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.3, cornerRadius: CGFloat? = nil) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
        if let r = cornerRadius {
            layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: r).cgPath
        }
    }
    
    func addShadow(with shadowProperties: AppShadowProperties) {
        self.layer.cornerRadius = shadowProperties.cornerRadius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = shadowProperties.roundedCorner
        } else {
            // Fallback on earlier versions
        }
        self.layer.shadowColor = shadowProperties.shadowColor.cgColor
        self.layer.shadowOffset = shadowProperties.offset
        self.layer.shadowOpacity = shadowProperties.opacity
        self.layer.shadowRadius = shadowProperties.shadowRadius
    }
    
}

//MARK: - Extension UIScreen
extension UIScreen {
    
    static var height: CGFloat {UIScreen.main.bounds.height}
    static var width: CGFloat {UIScreen.main.bounds.width}
    
}

struct AppShadowProperties {
    
    enum RoundedCorner{
        case top, bottom, all, none
    }
    
    let cornerRadius:CGFloat
    let shadowColor:UIColor
    let offset:CGSize
    let opacity:Float
    let shadowRadius: CGFloat
    private let roundCornerType:RoundedCorner
    
    var roundedCorner:CACornerMask{
        switch  roundCornerType{
        case .top:
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottom:
            return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .all:
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .none:
            return []
        }
    }
    
    init(cornerRadius: CGFloat = 12.0, shadowColor: UIColor = .black.withAlphaComponent(0.5), offset: CGSize = CGSize(width: 0, height: 1), opacity: Float = 0.8, shadowRadius: CGFloat = 4, roundCornerType: RoundedCorner  = .none) {
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.offset = offset
        self.opacity = opacity
        self.shadowRadius = shadowRadius
        self.roundCornerType = roundCornerType
    }
    
}

//MARK: - Extension UICollectionView
extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 20, y: 0, width: self.bounds.size.width - 40, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .blue
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = .systemFont(ofSize: 16, weight: .bold)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
}
