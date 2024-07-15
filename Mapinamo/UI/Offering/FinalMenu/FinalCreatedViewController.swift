import UIKit
import RxSwift

class FinalCreatedViewController: UIViewController {
    
    private var treasureId: CLongLong!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupTreasureId(_ treasureId: CLongLong) {
        self.treasureId = treasureId
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        if let name = URL(string: "https://mapinamo.app.link/open_treasure?treasure_id=\(self.treasureId.description)"), !name.absoluteString.isEmpty {
            let objectsToShare = [name]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func homeButtonAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
