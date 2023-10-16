import Foundation
import UIKit

/*@IBDesignable */
public class MGradientButton: UIButton {
    
    struct GradientParams {
        let startColor: UIColor
        let endColor: UIColor
    }
    
    private(set) var gradientLayer: CAGradientLayer?
    
    private var backgroundGradients = [UIControl.State: GradientParams]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {}
    
    private var backgroundGradient: GradientParams? {
        didSet {
            
            gradientLayer?.removeFromSuperlayer()
            
            gradientLayer = CAGradientLayer()
            
            if let gradientLayer = gradientLayer {
                gradientLayer.cornerRadius = 3
                gradientLayer.frame.size = self.frame.size
                
                if let backgroundGradient = backgroundGradient {
                    gradientLayer.colors = [backgroundGradient.startColor.cgColor, backgroundGradient.endColor.cgColor]
                }
                
                layer.insertSublayer(gradientLayer, below: nil)
                onGradientLayerChanged(gradientLayer)
            }
        }
    }
    
    func onGradientLayerChanged(_ gradientLayer: CAGradientLayer) {}
    
}

// MARK: - imageEdgeInsets support

extension MGradientButton {
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

extension MGradientButton {
    public override var isSelected: Bool {
        didSet { updateBackgroundColor() }
    }
    
    public override var isHighlighted: Bool {
        didSet { updateBackgroundColor() }
    }
    
    public override var isEnabled: Bool {
        didSet { updateBackgroundColor() }
    }
    
    private func updateBackgroundColor() {
        backgroundGradient = chooseBackgroundGradient()
    }
    
    private func chooseBackgroundGradient() -> GradientParams? {
        if !isEnabled, let color = backgroundGradients[.disabled] {
            return color
        }
        if isHighlighted, let color = backgroundGradients[.highlighted] {
            return color
        }
        if isSelected, let color = backgroundGradients[.selected] {
            return color
        }
        return backgroundGradients[.normal]
    }
    
    func setBackgroundGradient(startColor: UIColor, endColor: UIColor, forUIControlState state: UIControl.State) {
        let gradientParams = GradientParams(startColor: startColor, endColor: endColor)
        if state == self.state {
            backgroundGradient = gradientParams
        }
        backgroundGradients[state] = gradientParams
    }
}
