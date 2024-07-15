import UIKit
import RxSwift
import SnapKit
import Lottie

enum OnLaunchNavigationEvent {
    case openTreasureDetails(_ treasureId: CLongLong)
    case openMain
}

class LaunchViewController: UIViewController {
    
    let navigationEvent = PublishSubject<OnLaunchNavigationEvent>()
    let disposedBag = DisposeBag()
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
    }
    
    private func setupObservers() {
        navigationEvent.subscribe(onNext: { (event) in
            self.handleOnLaunchEvent(event)
        }).disposed(by: disposedBag)
    }
    
    private func handleOnLaunchEvent(_ event: OnLaunchNavigationEvent) {
        DispatchQueue.main.async {
            switch event {
            case .openTreasureDetails(let treasureId):
                switch UIApplication.shared.visibleViewController {
                case let vc as TreasureMapViewController:
                    vc.openTreasure(treasureId)
                case _ as LaunchViewController:
                    let nav = StoryboardScene.MenuScreen.initialScene.instantiate()
                    let mainVc = nav.viewControllers.first as! MenuViewController
                    mainVc.setupOnLaunchTreasureId(treasureId)
                    self.show(nav, sender: nil)
                default:
                    let vc = StoryboardScene.FindScreen.initialScene.instantiate()
                    vc.setupOnLaunchTreasureId(treasureId)
                    UIApplication.shared.visibleViewController?.show(vc, sender: nil)
                    break
                }
                
                break
            case .openMain:
                self.showMainScreen()
            }
        }
    }
    
    private func showMainScreen() {
        let settingApi = DIContainer.shared.provide(ofClass: SettingsAPI.self)
        settingApi.getVersion { (version, error) in
            if (version?.data.version == 0)
            {
                self.show(StoryboardScene.MenuScreen.initialScene.instantiate(), sender: nil)
            }
            else
            {
                self.present(StoryboardScene.UpdateScreen.initialScene.instantiate(), animated: true, completion: nil)
            }
        }
    }
}

