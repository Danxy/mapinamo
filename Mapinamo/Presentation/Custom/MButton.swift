import Foundation
import UIKit

/*@IBDesignable */
public class MButton: UIButton {
    private var backgroundColors = [UIControl.State: UIColor]()
    private var borderColors     = [UIControl.State: UIColor]()
    
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

// MARK: - imageEdgeInsets support

extension MButton {
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + imageEdgeInsets.left + imageEdgeInsets.right + titleEdgeInsets.left + titleEdgeInsets.right,
                      height: size.height)
    }
    
    public override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let dx = effectiveUserInterfaceLayoutDirection == .leftToRight
            ? -imageEdgeInsets.right
            : imageEdgeInsets.left
        return super.imageRect(forContentRect: contentRect).offsetBy(dx: dx, dy: 0)
    }
}

// MARK: - backgroundColors support

extension MButton {
    public override var isSelected: Bool {
        didSet {
            updateBackgroundColor()
            updateBoarderColor()
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            updateBackgroundColor()
            updateBoarderColor()
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
            updateBoarderColor()
        }
    }
    
    private func updateBackgroundColor() {
        backgroundColor = chooseBackgroundColor()
    }
    
    
    private func updateBoarderColor() {
        if !borderColors.isEmpty
        {
            self.layer.borderColor = chooseBorderColor()?.cgColor
        }
    }
    
    private func chooseBackgroundColor() -> UIColor? {
        if !isEnabled, let color = backgroundColors[.disabled] {
            return color
        }
        if isHighlighted, let color = backgroundColors[.highlighted] {
            return color
        }
        if isSelected, let color = backgroundColors[.selected] {
            return color
        }
        return backgroundColors[.normal]
    }
    
    
    private func chooseBorderColor() -> UIColor? {
        if !isEnabled, let color = borderColors[.disabled] {
            return color
        }
        if isHighlighted, let color = borderColors[.highlighted] {
            return color
        }
        if isSelected, let color = borderColors[.selected] {
            return color
        }
        return borderColors[.normal]
    }
    
    func setBackgroundColor(color: UIColor, forUIControlState state: UIControl.State) {
        if state == self.state {
            backgroundColor = color
        }
        backgroundColors[state] = color
    }
    
    
    func setBorderColor(color: UIColor, forUIControlState state: UIControl.State) {
        if state == self.state {
            self.layer.borderColor = color.cgColor
        }
        borderColors[state] = color
    }
}

extension UIControl.State: Hashable {
    public var hashValue: Int { return Int(rawValue) }
}
