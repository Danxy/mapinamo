import UIKit

class MainButton: MButton {
    
    override func setup() {
        super.setup()
        self.layer.cornerRadius = 22
        self.backgroundColor = UIColor(named: "green")
        self.titleLabel?.font = FontFamily.Roboto.medium.font(size: 22)
        self.setTitleColor(UIColor(named: "blue_purple"), for: UIControl.State.normal)
        self.setTitleColor(UIColor(named: "blue_purple"), for: UIControl.State.highlighted)
        self.setTitleColor(UIColor(named: "blue_purple")?.withAlphaComponent(0.8), for: UIControl.State.disabled)
        
        self.setBackgroundColor(color: UIColor(named: "green_selected")!, forUIControlState: .highlighted)
        self.setBackgroundColor(color: UIColor(named: "green")!, forUIControlState: .normal)
        self.setBackgroundColor(color: UIColor(named: "green")!.withAlphaComponent(0.3), forUIControlState: .disabled)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
