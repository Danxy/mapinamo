import Foundation
import RxCocoa
import RxSwift
import SwiftLocation
import CoreLocation



enum PlaceTreasureEvent {
    case goToTreasureCreatedVC
}

class DetailsViewModel: ImagePickableProtocol {
    
    let navigationEvent: PublishSubject<PlaceTreasureEvent> = PublishSubject<PlaceTreasureEvent>()
    
    var imageObservable: Observable<UIImage?> {
        return image.asObservable()
    }
    
    var categories: Observable<[TreasureCategory]> {
        return Observable.just(TreasureCategory.allCases)
    }
    var categoryObservable: Observable<TreasureCategory> {
        return category.asObservable()
    }
    var nameObservable: Observable<String> {
        return name.asObservable()
    }
    var descriptionObservable: Observable<String> {
        return description.asObservable()
    }
    
    private var image: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    private var place: BehaviorRelay<Place?> = BehaviorRelay(value: nil)
    private var name: BehaviorRelay<String> = BehaviorRelay(value: "")
    private var description: BehaviorRelay<String> = BehaviorRelay(value: "")
    private var category: BehaviorRelay<TreasureCategory> = BehaviorRelay(value: .other)
    private var treasureId: BehaviorRelay<Int?> = BehaviorRelay(value: nil)
    
    var treasureModel: TreasureRequest!
    
    init(image          : UIImage,
         treasureModel  : TreasureRequest)
    {
        self.treasureModel = treasureModel
        self.image.accept(image)
        setupCategory(.other)
    }
    
    func setupImage(_ image: UIImage?) {
        self.image.accept(image)
    }
    
    func getImage() -> UIImage {
        return self.image.value ?? UIImage()
    }
    
    func setupCategory(_ category: TreasureCategory) {
        self.category.accept(category)
        treasureModel.type = category.rawValue
    }
    
    func setupName(_ name: String) {
        self.name.accept(name)
        treasureModel.name = name
    }
    
    func setupDescription(_ description: String) {
        self.description.accept(description)
        treasureModel.comment = description
    }
    
    func getTreasuredID() -> Int {
        return self.treasureId.value ?? -1
    }
}
