import UIKit

protocol Localizable {
    var localized: String { get }
}
extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

protocol UILocalizable {
    var localizationKey: String? { get set }
}

extension UILabel: UILocalizable {
    @IBInspectable var localizationKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}
extension UIButton: UILocalizable {
    @IBInspectable var localizationKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}
