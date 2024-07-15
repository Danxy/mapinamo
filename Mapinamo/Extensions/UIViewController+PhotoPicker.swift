import UIKit

import AVFoundation

protocol ImagePickableViewControllerProtocol: ImagePickableViewModel where Self: UIViewController {}

extension ImagePickableViewControllerProtocol
{
    func pickPhoto() {
        let alertController = UIAlertController(title: "Chose photo", message: "Please chose photo", preferredStyle: (UIDevice.current.userInterfaceIdiom == .pad) ? .alert : .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {_ in
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized
            {
                self.presentImagePickerController(sourceType: .camera)
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        self.presentImagePickerController(sourceType: .camera)
                    } else {
                        self.alert("Error", message: "Please give us permission to use camera, without, you wont be able to create treasre")
                    }
                })
            }
        }
        
        let galeryAction = UIAlertAction(title: "Galery", style: .default) {_ in
            self.presentImagePickerController(sourceType: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galeryAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentImagePickerController(sourceType: UIImagePickerController.SourceType)
    {
        DispatchQueue.main.async {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            pickerController.allowsEditing = false
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = sourceType
            self.present(pickerController, animated: true, completion: nil)
        }
    }
}

protocol ImagePickableViewModel {
    var viewModel: ImagePickableProtocol {get}
}

protocol ImagePickableProtocol {
    func setupImage(_ image: UIImage?)
}

