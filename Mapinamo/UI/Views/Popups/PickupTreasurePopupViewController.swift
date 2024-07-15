import UIKit

class PickupTreasurePopupViewController: UIViewController {
    
    var confirmButtonAction: (()->Void)?
    var cancelButtonAction : (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        }
    }
    
    @IBAction func crossButtonAction(_ sender: Any)
    {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.clear
        }completion: { (bool) in
            self.dismiss(animated: true) {
                self.cancelButtonAction?()
            }
        }
    }
    
    @IBAction func confirmButtonAction(_ sender: Any)
    {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.clear
        }completion: { (bool) in
            self.dismiss(animated: true) {
                self.confirmButtonAction?()
            }
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any)
    {
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.clear
        }completion: { (bool) in
            self.dismiss(animated: true) {
                self.cancelButtonAction?()
            }
        }
    }
}
