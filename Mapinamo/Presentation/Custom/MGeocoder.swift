import UIKit
import SwiftLocation
import CoreLocation

class MGeocoder {
    static let shared = MGeocoder()
    
    private var coordinates: CLLocationCoordinate2D?
    private var task: DispatchWorkItem?
    public var result: ((Place?)->Void)?
    
    public func geocodeFrom(coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
        task?.cancel()
        task = DispatchWorkItem {
            self.getLocationFromCoordinates()
        }
        DispatchQueue.global(qos: .default).asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task!)
        
    }
    
    private func getLocationFromCoordinates() {
        guard let coordinates = coordinates else {return}
        let service = Geocoder.Apple(coordinates: coordinates)
        service.execute { result in
            switch result {
            case .success(let success):
                guard success is [GeoLocation] else { return }
            case .failure(let failure):
                    var fail = failure
            }
        }
//        LocationManager.shared.locateFromCoordinates(coordinates!) { (result) in
//            switch result {
//            case .failure(let error):
//                debugPrint("An error has occurred: \(error)")
//                self.result?(nil)
//            case .success(let places):
//                guard let place = places.first else {return}
//                self.result?(place)
//            }
//        }
    }
    
    private init() {}
}

//TODO: Coplete parsing, adapt results from old model.

public class Place {
    
}
