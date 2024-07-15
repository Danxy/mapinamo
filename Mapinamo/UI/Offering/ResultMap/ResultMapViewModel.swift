import Foundation
import RxCocoa
import RxSwift
import SwiftLocation
import CoreLocation

class ResultMapViewModel {
    
    let navigationEvent: PublishSubject<PlaceTreasureEvent> = PublishSubject<PlaceTreasureEvent>()
    
    private let treasureAPI: TreasuresAPI!
    private var treasureModel: TreasureRequest!
    
    private let treasureId: BehaviorRelay<CLongLong?> = BehaviorRelay(value: nil)
    
    private let image: UIImage!
    
    init(treasureAPI: TreasuresAPI,
         treasureModel: TreasureRequest,
         image: UIImage)
    {
        self.treasureAPI = treasureAPI
        self.treasureModel = treasureModel
        self.image = image
    }
    
    func getTreasuredID() -> CLongLong {
        return self.treasureId.value ?? -1
    }
    
    func getLocation() -> CLLocationCoordinate2D {
        let serverLatitude = Double(treasureModel.latitude) / 1e8
        let serverLongitude = Double(treasureModel.longitude) / 1e8
        return CLLocationCoordinate2D(latitude: serverLatitude, longitude: serverLongitude)
    }
    
    func getTreasureName() -> String
    {
        return treasureModel.name
    }
    
    func getTreasureCategory() -> String
    {
        return treasureModel.type
    }
    
    func getTreasureDescription() -> String
    {
        return treasureModel.comment
    }
    
    func getImage() -> UIImage
    {
        return image
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func placeTreasure() {
        self.treasureModel.isPrivate = false
        self.treasureModel.date = Int64(Date().timeIntervalSince1970.rounded() * 1000)
        self.treasureAPI.createTreasure(body: self.treasureModel) { (response, error) in
            if (error == nil) {
                guard let image = self.image else { return }
                guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
                self.treasureAPI.uploadImage(imageData, id: response!.data.id, completion: { isCompleted, error in
                    if (error == nil) {
                        self.treasureId.accept(response?.data.id)
                        self.navigationEvent.onNext(.goToTreasureCreatedVC)
                    }
                })
            }
        }
    }
}
