import Foundation
import UIKit

@IBDesignable
public class MLabel: UILabel {
    private var _contentInsets: UIEdgeInsets = UIEdgeInsets.zero
    private var _markdownText: String?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {}
}

extension MLabel {
    @IBInspectable
    var fontSize: CGFloat {
        set {
            font = font.withSize(newValue)
        }
        get {
            return font.pointSize
        }
    }
}

extension MLabel {
    @IBInspectable
    var contentInsets: String {
        set {
            _contentInsets = NSCoder.uiEdgeInsets(for: "{\(newValue)}")
        }
        get {
            return String(NSCoder.string(for: _contentInsets).dropFirst().dropLast())
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + _contentInsets.left + _contentInsets.right,
                      height: size.height + _contentInsets.top + _contentInsets.bottom)
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: _contentInsets.left, dy: _contentInsets.top))
    }
}
