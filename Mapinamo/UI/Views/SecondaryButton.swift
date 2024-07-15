import UIKit

class SecondaryButton: MButton {
    
    override func setup() {
        super.setup()
        self.layer.cornerRadius = 22
        self.backgroundColor = UIColor.clear
        self.titleLabel?.font = FontFamily.Roboto.medium.font(size: 22)
        self.setTitleColor(UIColor(named: "green"), for: UIControl.State.normal)
        self.setTitleColor(UIColor(named: "green_selected"), for: UIControl.State.highlighted)
        self.setTitleColor(UIColor(named: "green")?.withAlphaComponent(0.8), for: UIControl.State.disabled)
        
        self.setBorderColor(color: UIColor(named: "green_selected")!, forUIControlState: .highlighted)
        self.setBorderColor(color: UIColor(named: "green")!, forUIControlState: .normal)
        self.setBorderColor(color: UIColor(named: "green")!.withAlphaComponent(0.3), forUIControlState: .disabled)
        self.layer.borderWidth = 2
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
