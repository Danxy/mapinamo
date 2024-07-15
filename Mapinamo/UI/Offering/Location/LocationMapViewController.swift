import UIKit
import GoogleMaps
import SwiftLocation
import RxSwift

class LocationMapViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var map: GMSMapView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var latNameLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngNameLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    @IBOutlet weak var createTreasureButton: MainButton!
    
    private var privateViewModel: LocationMapViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        addObservers()
        setupMap()
        setupUI()
        MGeocoder.shared.result = gAddressReceived
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        goToCurrentLocation()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupViewModel() {
        self.privateViewModel = LocationMapViewModel(treasureAPI: DIContainer.shared.provide(ofClass: TreasuresAPI.self))
    }
    
    private func addObservers() {
//        privateViewModel.imageObservable.subscribe(onNext: { img in
//            guard img != nil else {return}
//            self.perform(segue: StoryboardSegue.CreateScreen.detailsSegue)
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        self.cityLabel.text = " "
        self.addressLabel.text = " "
        self.cityLabel.text = " "
        self.addressLabel.text = " "
        self.latLabel.text = " "
        self.lngLabel.text = " "
    }
    
    private func setupMap() {
        setupMapStyle(map)
        map.delegate = self
        map.isMyLocationEnabled = true
        map.settings.rotateGestures = false
        map.settings.tiltGestures = false
    }
    
    private func goToCurrentLocation() {
        guard let location = map.myLocation?.coordinate else {
            showLocationFetchingErrorAlert()
            return
        }
        map.animate(toZoom: 16)
        map.animate(toLocation: location)
        MGeocoder.shared.geocodeFrom(coordinates: location)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailsViewController {
            vc.setupViewModel(self.privateViewModel)
        }
    }
    
    private func presentPickerController() {
        self.pickPhoto()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func myLocationButtonAction(_ sender: UIButton) {
        goToCurrentLocation()
    }
    
    @IBAction func createButtonAction(_ sender: UIButton) {
        onLocationEnabled
        { (location) in
            self.perform(segue: StoryboardSegue.CreateScreen.detailsSegue)
//            self.presentPickerController()
        }
        onDisabled: { (error) in
            self.alert(L10n.locatonErrorTitle, message: L10n.locatonErrorMessage)
        }
    }
}

extension LocationMapViewController: GMSMapViewDelegate {
    func gAddressReceived(place: Place?) {
        guard let place = place else {
            self.createTreasureButton.isEnabled = false
            self.latLabel.text = " "
            self.lngLabel.text = " "
            return
        }
        self.privateViewModel.setupTreasureLocation(place)
        self.cityLabel.text = place.city
        self.addressLabel.text = "\(place.streetAddress ?? "") \( place.streetNumber ?? "")"
        do {
            self.latLabel.text = " \(place.coordinates?.latitude.description[0...8] ?? " ")"
            self.lngLabel.text = " \(place.coordinates?.longitude.description[0...8] ?? " ")"
            self.createTreasureButton.isEnabled = true
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let location = mapView.projection.coordinate(for: mapView.center)
        let coordinates = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        MGeocoder.shared.geocodeFrom(coordinates: coordinates)
    }
}

extension LocationMapViewController
{
    var viewModel: ImagePickableProtocol {
        return self.privateViewModel
    }
}

extension LocationMapViewController: ImagePickableViewControllerProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            self.viewModel.setupImage(nil)
            picker.dismiss(animated: true, completion: nil)
            return
        }
        self.viewModel.setupImage(image)
        picker.dismiss(animated: true, completion: nil)
    }
}
