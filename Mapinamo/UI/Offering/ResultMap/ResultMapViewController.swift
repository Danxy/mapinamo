import UIKit
import GoogleMaps
import RxSwift
import SwiftLocation
import IDMPhotoBrowser
import Lottie

class ResultMapViewController: UIViewController {
    
    @IBOutlet weak var map: GMSMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var treasureDescriptionLabel: UILabel!
    @IBOutlet weak var showPhotoButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: ResultMapViewModel!
    private var animationView: AnimationView!
    
    override func loadView() {
        super.loadView()
        setupMapStyle(map)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservers()
    }
    
    private func setupUI()
    {
        self.setupMarkerWithLocation(viewModel.getLocation())
        self.map.animate(toLocation: viewModel.getLocation())
        self.map.animate(toZoom: 16)
        
        self.nameLabel.text = viewModel.getTreasureName()
        self.categoryLabel.text = viewModel.getTreasureCategory()
        self.treasureDescriptionLabel.text = "«\(viewModel.getTreasureDescription())»"
    }
    
    private func setupObservers()
    {
        viewModel.navigationEvent.subscribe(onNext: { (event) in
            switch event {
            case .goToTreasureCreatedVC:
                self.perform(segue: StoryboardSegue.CreateScreen.finalCreatedSegue)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupMarkerWithLocation(_ location: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: location)
        marker.icon = #imageLiteral(resourceName: "marker-green")
        marker.map = map
    }
    
    func setupViewModel(_ viewModel: DetailsViewModel) {
        self.viewModel = ResultMapViewModel(treasureAPI: DIContainer.shared.provide(ofClass: TreasuresAPI.self),
                                                treasureModel: viewModel.treasureModel,
                                                image: viewModel.getImage())
    }
    
    private func openImageViewer(_ images: [UIImage]) {
        let photos = IDMPhoto.photos(withImages: images)
        guard let browser = IDMPhotoBrowser(photos: photos) else {return}
        browser.forceHideStatusBar = true
        present(browser, animated: true, completion: nil)
    }
    
    private func showAnimation() {
        animationView = .init(name: "loading")
        animationView.frame = view.bounds
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        view.addSubview(animationView)
        animationView.play()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? FinalCreatedViewController else { return }
        vc.setupTreasureId(viewModel.getTreasuredID())
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func placeTreasureButton(_ sender: Any) {
        showAnimation()
        self.viewModel?.placeTreasure()
    }
    
    @IBAction func showPhotoButtonAction(_ sender: UIButton) {
        openImageViewer([viewModel.getImage()])
    }
}
