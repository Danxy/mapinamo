import UIKit
import GoogleMaps
//import GoogleMapsUtils
import RxSwift
import IDMPhotoBrowser
import SwiftLocation
import Lottie

class TreasureMapViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var onLaunchTreasureId: CLongLong?
    
    @IBOutlet weak var map: GMSMapView!
//    private var clusterManager: GMUClusterManager!
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var treasureNameLabel: UILabel!
    @IBOutlet weak var treasureCategoryLabel: UILabel!
    @IBOutlet weak var treasureDescriptionLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var treasureCreatedDateLabel: UILabel!
    
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var selectCategoryTextField: MapinamoTextField!
    @IBOutlet weak var lblItemsFound: UILabel!
    @IBOutlet weak var lblNewItems: UILabel!
    @IBOutlet weak var navigateButton: UIButton!
    
    @IBOutlet weak var itemImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryViewHeightContstraint: NSLayoutConstraint!
    
    private var animationView: AnimationView!
    private var lastSelectedCategoryIndex: Int = 0
    
    private var isMapMoved = false
    
    var viewModel: TreasureMapViewModel!
    private var pickerView: UIPickerView!
    
    private var selectedMarker: GMSMarker? {
        didSet {
            navigateButton.isHidden = selectedMarker == nil
        }
    }
    
    private var selectedMarkerTreasureId: CLongLong {
        guard let id = (selectedMarker?.userData as? Dictionary<String, CLongLong>)?["treasureId"] else {return -1}
        return id
    }
    
    private var markers: [GMSMarker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapStyle(map)
        map.isMyLocationEnabled = true
//        let iconGenerator = GMUDefaultClusterIconGenerator()
//        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
//        let renderer = GMUDefaultClusterRenderer(mapView: map, clusterIconGenerator: iconGenerator)
//        clusterManager = GMUClusterManager(map: map, algorithm: algorithm, renderer: renderer)
//        clusterManager.setMapDelegate(self)
        
        setupPickerView()
        setupViewModel()
        setupObservers()
        addGestureRecognizers()
        getTreasures()
        if onLaunchTreasureId != nil {
            viewModel.getTreasureRequest(onLaunchTreasureId!)
            onLaunchTreasureId = nil
        }
    }
    
    private func setupPickerView() {
        pickerView = UIPickerView()
        selectCategoryTextField.inputView = pickerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        goToCurrentLocation()
        self.getTreasures()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupViewModel() {
        viewModel = TreasureMapViewModel(treasureAPI: DIContainer.shared.provide(ofClass: TreasuresAPI.self))
    }
    
    private func addGestureRecognizers() {
        let itemImageViewTapGestureRecognozer = UITapGestureRecognizer(target: self, action: #selector(itemImageTapAction))
        itemImageView.isUserInteractionEnabled = true
        itemImageView.addGestureRecognizer(itemImageViewTapGestureRecognozer)
        
        let detailsViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(detailsViewTapAction))
        detailsView.isUserInteractionEnabled = true
        detailsView.addGestureRecognizer(detailsViewGestureRecognizer)
    }
    
    @objc private func itemImageTapAction() {
        self.openImageViewer() 
    }
    
    @objc private func detailsViewTapAction() {
        self.openMarkerDetails()
    }
    
    
    private func setupObservers() {
        pickerView.rx.itemSelected.asObservable().subscribe(onNext: {item in
            self.isMapMoved = false
            self.lastSelectedCategoryIndex = item.row
            self.getTreasures(item.row)
        }).disposed(by: disposeBag)
        
        viewModel.categoriesObservable.bind(to: pickerView.rx.itemTitles) { row, element in
            return element.categoryTitle + "   \(element.size) Results"
        }.disposed(by: disposeBag)
        
        viewModel.categoryObservable.subscribe(onNext: { (category) in
            self.selectCategoryTextField.text = category.categoryTitle + "   \(category.size) Results"
        }).disposed(by: disposeBag)
        
        viewModel.stateObservable.subscribe(onNext: { (state) in
            switch state {
            case .choseCategory: self.showCategoryView()
            case .pickupTreasure: self.showDetailsView()
            }
        }).disposed(by: disposeBag)
        
        viewModel.treasuresObservable.subscribe(onNext: { (treasures) in
            self.setupMarkers(treasures)
            self.setupCategoryView(treasures)
        }).disposed(by: disposeBag)
        
        viewModel.selectedTreasureObservable.subscribe(onNext: { (treasure) in
            guard let treasure = treasure else { return }
            if let marker = self.getMarkerForTreasure(treasure) {
                self.selectedMarker?.icon = #imageLiteral(resourceName: "marker-perple")
                self.selectedMarker = marker
                self.isMapMoved = false
                marker.icon = #imageLiteral(resourceName: "marker-green")
                marker.map = self.map
            }
            self.setupDetailsViewWith(treasure)
        }).disposed(by: disposeBag)
        
        viewModel.imagesObservable.subscribe(onNext: { (urls) in
            guard let urls = urls else {return}
            if (urls.count > 0) {
                guard let imageUrl = urls.first else { return }
                self.itemImageView.sd_setImage(with: URL(string: imageUrl)) { (image,error, cache, url)  in
                    guard let image = image else { return }
                    let ratio = image.size.width / image.size.height
                    let newHeight = self.itemImageView.frame.width / ratio
                    self.itemImageViewHeightConstraint.constant = newHeight
                    self.view.layoutIfNeeded()
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.navEventObservable.subscribe(onNext: { (navEvent) in
            self.handleNavEvent(navEvent)
        }).disposed(by: disposeBag)
        observeCurrentLocation()
    }
    
    public func setupOnLaunchTreasureId(_ id: CLongLong) {
        onLaunchTreasureId = id
    }
    
    private func goToCurrentLocation() {
        guard let location = map.myLocation?.coordinate else {
            showLocationFetchingErrorAlert()
            return
        }
        map.animate(toLocation: location)
        map.animate(toZoom: 16)
    }
    
    private func getTreasures(_ categoryIndex: Int = 0) {
        let location = self.map.projection.coordinate(for: self.map.center)
        let serverLatitude = Int(location.latitude * 1e8)
        let serverLongitude = Int(location.longitude * 1e8)
        self.viewModel.getTreasures(latitude: serverLatitude , longitude: serverLongitude, categoryIndex: categoryIndex)
    }
    
    private func showCategoryView() {
        self.viewModel.unselectTreasure()
        UIView.animate(withDuration: 0.2, animations: {
            self.detailsViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { isCompleted in
            UIView.animate(withDuration: 0.1) {
                self.categoryViewHeightContstraint.constant = 184
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func showDetailsView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.categoryViewHeightContstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { isCompleted in
            UIView.animate(withDuration: 0.1) {
                self.detailsViewHeightConstraint.constant = 248
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func setupMarkers(_ treasures: [TreasureData]) {
//        clusterManager.clearItems()
        map.clear()
        markers.removeAll()
//        var bounds = GMSCoordinateBounds()
        treasures.forEach { (treasure) in
            let marker = createMarkerForTreasure(treasure)
            // if one of markers was selected, we have to select it again
            if let selectedMarkerData = selectedMarker?.userData as? Dictionary<String, CLongLong>, selectedMarkerData["treasureId"] == treasure.id  {
                marker.icon = #imageLiteral(resourceName: "marker-green")
                selectedMarker = marker
            }
//            clusterManager.add(marker)
            marker.map = self.map
            markers.append(marker)
//            bounds = bounds.includingCoordinate(marker.position)
        }
//        clusterManager.cluster()
//
//        let shouldShowCluster = viewModel.getSelectedTreasure() == nil && treasures.count > 1 && isMapMoved == false
//        let shouldShowItem = viewModel.getSelectedTreasure() == nil && treasures.count == 1 && isMapMoved == false
//
//        if shouldShowCluster  {
//            let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
//            map.animate(with: update)
//            isMapMoved = false
//        } else if shouldShowItem {
//            let serverLatitude = Double(treasures[0].coords?.latitude ?? 0) / 1e8
//            let serverLongitude = Double(treasures[0].coords?.longitude ?? 0) / 1e8
//            let location = CLLocationCoordinate2D(latitude: serverLatitude, longitude: serverLongitude)
//            map.animate(toLocation: location)
//            map.animate(toZoom: 16)
//            isMapMoved = false
//        }
    }
    
    private func setupCategoryView(_ treasures: [TreasureData]) {
        self.lblItemsFound.text = treasures
            .count.description + " items found"
        
        let count = treasures.reduce(0) {($1.picked ?? true) ? $0 : $0 + 1}
        self.lblNewItems.text = count.description + " new items"
        selectCategoryTextField.isEnabled = true
    }
    
    private func setupDetailsViewWith(_ treasureData: TreasureData) {
        showDetailsView()
        treasureNameLabel.text = treasureData.name?.uppercased()
        treasureCategoryLabel.text = treasureData.type
        treasureDescriptionLabel.text = "«\(treasureData.comment ?? "No comments")»"

        let dateInt = treasureData.date
        let date = Date(timeIntervalSince1970: Double(dateInt) / 1000)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
        formatter.locale = .current
        treasureCreatedDateLabel.text = formatter.string(from: date)
        
        let serverLatitude = Double(treasureData.coords?.latitude ?? 0) / 1e8
        let serverLongitude = Double(treasureData.coords?.longitude ?? 0) / 1e8
        let location = CLLocationCoordinate2D(latitude: serverLatitude, longitude: serverLongitude)
        map.animate(toLocation: location)
    }
    
    private func openImageViewer() {
        guard let image = self.itemImageView.image else { return }
        let photos = IDMPhoto.photos(withImages: [image])
        guard let browser = IDMPhotoBrowser(photos: photos) else {return}
        browser.forceHideStatusBar = true
        present(browser, animated: true, completion: nil)
    }
    
    private func openMarkerDetails() {
        performSegue(withIdentifier: StoryboardSegue.FindScreen.markerDetailsSegue.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let markerDetails = segue.destination as? MarkerDetailsViewController,
              let selectedTreasure = self.viewModel.getSelectedTreasure(),
              let selectedImage = self.viewModel.getSelectedImages() else {return}
        
        let treasureApi = DIContainer.shared.provide(ofClass: TreasuresAPI.self)
        markerDetails.viewModel = MarkerDetailsViewModel(treasureAPI: treasureApi,
                                                         selectedTreasure: selectedTreasure,
                                                         selectedImages: selectedImage)
    }
    
    private func handleNavEvent(_ navEvent: NavigationEvent) {
        switch navEvent {
        case .treasurePicked:
            performSegue(withIdentifier: StoryboardSegue.FindScreen.finalPickedSegue.rawValue, sender: nil)
        }
    }
    
    private func getMarkerForTreasure(_ treasure: TreasureData) -> GMSMarker? {
        let marker = markers.first { marker  in
            let markerId = (marker.userData as? Dictionary<String, CLongLong>)?["treasureId"]
            return markerId == treasure.id
        }
        return marker ?? createMarkerForTreasure(treasure)
    }
    
    private func createMarkerForTreasure(_ treasure: TreasureData) -> GMSMarker {
        let serverLatitude = Double(treasure.coords?.latitude ?? 0) / 1e8
        let serverLongitude = Double(treasure.coords?.longitude ?? 0) / 1e8
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: serverLatitude, longitude: serverLongitude))
        marker.icon = (treasure.picked ?? false) ? #imageLiteral(resourceName: "marker-perple").image(alpha: 0.5) : #imageLiteral(resourceName: "marker-perple")
        marker.userData = ["treasureId": treasure.id]
        return marker
    }
    
    public func openTreasure(_ id: CLongLong) {
        viewModel.getTreasureRequest(id)
    }
    
    private func observeCurrentLocation()
    {
        LocationManager.shared.locateFromGPS(.continous, accuracy: .house) {[weak self] (result) in
            guard let self = self else {return}
            switch result
            {
            case .success(let location):
                if self.viewModel.getSelectedTreasure() != nil {
                    self.validateTreasurePickupDistance(location)
                }
            case .failure(_):
                self.showLocationFetchingErrorAlert()
            }
        }
    }
    
    //should be in vm
    private func validateTreasurePickupDistance(_ currentLocation: CLLocation)
    {
        let selectedTreasure = viewModel.getSelectedTreasure()
        
        guard let selectedMarker = selectedMarker, (selectedTreasure?.picked ?? true) == false else
        { return }
        let selectedMarketLocation = CLLocation(latitude: selectedMarker.position.latitude, longitude: selectedMarker.position.longitude)

        
    }
    
    private func showAnimation() {
        animationView = .init(name: "loading")
        animationView.frame = view.bounds
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        view.addSubview(animationView)
        animationView.play()
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func myLocationButtonAction(_ sender: UIButton) {
        goToCurrentLocation()
    }
    
    
    @IBAction func navigateButtonAction(_ sender: Any) {
        showDirectionsPicker()
    }
    
    private func showDirectionsPicker()
    {
        let alertController = UIAlertController(title: "Show direction", message: "Please chose app", preferredStyle: .actionSheet)
        
        let appleMaps = UIAlertAction(title: "Apple Maps", style: .default) {_ in
            UIApplication.shared.open(URL(string:"http://maps.apple.com/?saddr=&daddr=\(self.selectedMarker?.position.latitude ?? 0),\(self.selectedMarker?.position.longitude ?? 0)")!)
        }
        
        let googleMaps = UIAlertAction(title: "Google Maps", style: .default) {_ in
            UIApplication.shared.open(URL(string: "comgooglemaps://?saddr=&daddr=\(self.selectedMarker?.position.latitude ?? 0),\(self.selectedMarker?.position.longitude ?? 0)&directionsmode=driving")!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(appleMaps)
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            alertController.addAction(googleMaps)
        }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}

extension TreasureMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let selectedTreasure = viewModel.getSelectedTreasure()
        showCategoryView()
        selectedMarker?.icon = (selectedTreasure?.picked ?? false) ? #imageLiteral(resourceName: "marker-perple").image(alpha: 0.5) : #imageLiteral(resourceName: "marker-perple")
        selectedMarker = nil
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        if let _ = marker.userData as? GMUCluster {
//            mapView.animate(toZoom: mapView.camera.zoom + 1)
//            return true
//        }
        mapView.animate(toLocation: marker.position)
        guard let id = (marker.userData as? Dictionary<String, CLongLong>)?["treasureId"] else {return false}
        viewModel.getImages(id)
        viewModel.getTreasureForId(id)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if viewModel.getSelectedTreasure() == nil && !isMapMoved {
            getTreasures(self.lastSelectedCategoryIndex)
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if viewModel.getSelectedTreasure() == nil {
            self.isMapMoved = gesture
            getTreasures(self.lastSelectedCategoryIndex)
        }
    }
}
