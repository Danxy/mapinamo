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
        LocationManager.shared.locateFromCoordinates(coordinates!) { (result) in
            switch result {
            case .failure(let error):
                debugPrint("An error has occurred: \(error)")
                self.result?(nil)
            case .success(let places):
                guard let place = places.first else {return}
                self.result?(place)
            }
        }
    }
    
    private init() {}
}
