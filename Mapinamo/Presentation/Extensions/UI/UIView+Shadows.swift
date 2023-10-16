import Foundation
import UIKit

struct ShadowParams {
    static let `default` = ShadowParams(
        color: UIColor.black,
        offset: CGSize(width: 1, height: 1),
        radius: 8,
        opacity: 0.5
    )
    
    static let no = ShadowParams()
    
    let offset: CGSize
    let color: UIColor
    let radius: CGFloat
    let opacity: Float
    
    init(color: UIColor = UIColor.clear,
         offset: CGSize = CGSize.zero,
         radius: CGFloat = 0,
         opacity: Float = 1.0) {
        self.color = color
        self.radius = radius
        self.offset = offset
        self.opacity = opacity
    }
}

extension UIView {
    var shadow: ShadowParams {
        set {
            layer.shadow = newValue
        }
        get {
            return layer.shadow
        }
    }
}

extension CALayer {
    var shadow: ShadowParams {
        set {
            shadowColor = newValue.color.cgColor
            shadowOffset = newValue.offset
            shadowRadius = newValue.radius
            shadowOpacity = newValue.opacity
            setNeedsDisplay()
        }
        get {
            return ShadowParams(color: UIColor(cgColor: shadowColor ?? UIColor.clear.cgColor),
                                offset: shadowOffset,
                                radius: shadowRadius,
                                opacity: shadowOpacity)
        }
    }
}
