import Foundation
import RxCocoa
import RxSwift
import SwiftLocation
import CoreLocation

class LocationMapViewModel: ImagePickableProtocol {
    
    let navigationEvent: PublishSubject<PlaceTreasureEvent> = PublishSubject<PlaceTreasureEvent>()
    
    var imageObservable: Observable<UIImage?> {
        return image.asObservable()
    }
    var placeObservable: Observable<Place?> {
        return place.asObservable()
    }
    
    private var image: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    private var place: BehaviorRelay<Place?> = BehaviorRelay(value: nil)
    
    private var treasureAPI: TreasuresAPI!
    
    var treasureModel : TreasureRequest
    
    init(treasureAPI: TreasuresAPI) {
        self.treasureAPI = treasureAPI
        self.treasureModel = TreasureRequest(date : Int64((Date().timeIntervalSince1970 * 1000.0).rounded()), isPrivate : false, type : "Other", comment : "", name : "", latitude : 0, longitude : 0, altitude : 0)
    }
    
    func setupTreasureLocation(_ place: Place) {
        self.place.accept(place)
        let latitude  = Int((place.coordinates?.latitude ?? 0.0) * 1e8)
        let longitude = Int((place.coordinates?.longitude ?? 0.0) * 1e8)
        
        treasureModel.latitude  = latitude
        treasureModel.longitude = longitude
        treasureModel.altitude  = 0
    }
    
    func setupImage(_ image: UIImage?) {
        self.image.accept(image)
    }
    
    func getImage() -> UIImage {
        return self.image.value ?? UIImage()
    }
}
