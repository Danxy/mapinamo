import UIKit

/*@IBDesignable*/
class MCustomView: UIView {
    
    override func awakeFromNib() {
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        addSubview(self.topView())
        topView().frame = self.bounds
        topView().autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func topView() -> UIView {
        return UIView(frame: CGRect.zero)
    }
    
}
