import UIKit

class FinalPickedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func homeButtonAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
