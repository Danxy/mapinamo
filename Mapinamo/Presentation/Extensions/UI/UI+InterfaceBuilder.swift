import Foundation
import UIKit

extension UIView {
    static func fromNib<T: UIView>(type: T.Type) -> T {
        let bundle = Bundle(for: type)
        let nibName = type.description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! T // swiftlint:disable:this force_cast
    }
    
    static func fromNib<T: UIView>() -> T {
        let bundle = Bundle(for: self)
        let nibName = description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! T // swiftlint:disable:this force_cast
    }
}

extension UIViewController {
    static func fromNib<T: UIViewController>(type: T.Type) -> T? {
        let bundle = Bundle(for: type)
        let nibName = type.description().components(separatedBy: ".").last!
        
        guard let _ = bundle.path(forResource: nibName, ofType: "nib") else { return nil }
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? T
    }
    
    static func fromStoryboard<T: UIViewController>(type: T.Type,
                                                    storyboardName knownStoryboardName: String? = nil) -> T? {
        let bundle = Bundle(for: type)
        
        let className = type.description().components(separatedBy: ".").last!
        
        let storyboardName = knownStoryboardName ?? className
        
        let storyboardIdentifier = className
        
        guard let _ = bundle.path(forResource: storyboardName, ofType: "storyboardc") else { return nil }
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        
        return (storyboard.instantiateInitialViewController() as? T)
            ?? (storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? T)
    }
    
    static func fromIB<T: UIViewController>(type: T.Type) -> T? {
        return fromStoryboard(type: type) ?? fromNib(type: type)
    }
    
    static func fromIB() -> Self? {
        return fromStoryboard(type: self) ?? fromNib(type: self)
    }
}
