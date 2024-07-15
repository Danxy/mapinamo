import UIKit

extension UIViewController {
    
    func showLocationFetchingErrorAlert() {
        alert("Location fetching error", message: "Please, turn on location permission in settings")
    }
}
