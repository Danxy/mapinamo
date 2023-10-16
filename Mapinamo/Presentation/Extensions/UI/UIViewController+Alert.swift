import UIKit

extension UIViewController
{
    func alert(_ title: String?, message: String?)
    {
        DispatchQueue.main.async
        {
            let alertController = UIAlertController(title: title ?? "Error", message: message ?? "Error occures", preferredStyle: .alert)
            
            let okActioon = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(okActioon)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showLocationFetchingErrorAlert() {
        alert("Location fetching error", message: "Please, turn on location permission in settings")
    }
}
