import UIKit
import SwiftLocation
import CoreLocation

extension UIViewController
{
    func onLocationEnabled(_ onEnabled: ((CLLocation)->())?) {

//    func onLocationEnabled(_ onEnabled: ((CLLocation)->())?, onDisabled: ((LocationManager.ErrorReason)->())? )
//    {
        LocationManager.shared.gpsLocation(accuracy: .room)
//        LocationManager.shared.locateFromGPS(.oneShot, accuracy: .city) {  result in
//            switch result
//            {
//            case .success(let location):
//                onEnabled?(location)
//            case .failure(let error):
//                onDisabled?(error)
//            }
//        }
    }
}
