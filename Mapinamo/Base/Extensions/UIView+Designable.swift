import Foundation
import UIKit

extension UIView {
    @IBInspectable public var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            setNeedsDisplay()
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
            setNeedsDisplay()
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
            setNeedsDisplay()
        }
        get {
            return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : nil
        }
    }
}

private var stringTagKey: Void?
extension UIView {
    @IBInspectable public var stringTag: String? {
        set {
            objc_setAssociatedObject(self, &stringTagKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &stringTagKey) as? String
        }
    }
}
