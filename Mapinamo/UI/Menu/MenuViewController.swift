import UIKit
import SwiftLocation

class MenuViewController: UIViewController {
    
    private var onLaunchTreasureId: CLongLong?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if onLaunchTreasureId != nil {
            perform(segue: StoryboardSegue.MenuScreen.findSegue)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationManager.shared.requireUserAuthorization(.whenInUse)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let treasureMapVc = segue.destination as? TreasureMapViewController else {return}
        treasureMapVc.setupOnLaunchTreasureId(onLaunchTreasureId ?? -1)
        onLaunchTreasureId = nil
    }
    
    public func setupOnLaunchTreasureId(_ id: CLongLong) {
        onLaunchTreasureId = id
    }
    
    @IBAction func infoButtonAction(_ sender: UIButton) {
        let aboutVC = AboutViewController(nibName: "AboutScreen", bundle: nil)
        present(aboutVC, animated: true)
    }
}

