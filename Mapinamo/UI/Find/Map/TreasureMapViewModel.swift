import Foundation
import RxSwift

enum State {
    case pickupTreasure
    case choseCategory
}

enum NavigationEvent {
    case treasurePicked
}

class TreasureMapViewModel {
    
    private let treasureAPI: TreasuresAPI
    private var task: DispatchWorkItem?
    
    var stateObservable: Observable<State> {
        return state.asObserver()
    }
    
    var treasuresObservable: Observable<[TreasureData]> {
        return treasures.asObserver()
    }
    
    var selectedTreasureObservable: Observable<TreasureData?> {
        return selectedTreasure.asObservable()
    }
    
    var imagesObservable: Observable<[String]?> {
        return images.asObservable()
    }
    
    var navEventObservable: Observable<NavigationEvent> {
        return navEvent.asObserver()
    }
    
    var categoryObservable: Observable<CategoryData> {
        return category.asObserver()
    }
    
    var categoriesObservable: Observable<[CategoryData]>
    {
        return categories.asObserver()
    }
//    enum TreasureCategory: String, CaseIterable {
//        case other       = "Other"
//        case furniture   = "🩸 blood donation"
//        case devices     = "\u{1F4AA} manpower"
//        case appliances  = "\u{1F9E6} goods for soldiers"
//        case clothes     = "\u{1F468}\u{200D}\u{1F469}\u{200D}\u{1F466}\u{200D}\u{1F466} goods for families"
//        case books       = "\u{1F372} home food"
//        case sport       = "\u{1F69B} drivers"
//    }
    var categoriesList = [
        CategoryData(categoryTitle: "All", size: 0),
        CategoryData(categoryTitle: "Other", size: 0),
        CategoryData(categoryTitle: "🩸 blood donation", size: 0),
        CategoryData(categoryTitle: "💪 manpower", size: 0),
        CategoryData(categoryTitle: "🧦 goods for soldiers", size: 0),
        CategoryData(categoryTitle: "👨‍👩‍👦‍👦 goods for families", size: 0),
        CategoryData(categoryTitle: "🍲 home food", size: 0),
        CategoryData(categoryTitle: "🚛 drivers", size: 0)
    ]
    
    private var selectedTreasure = BehaviorSubject<TreasureData?>(value: nil)
    private let category = BehaviorSubject<CategoryData>(value: CategoryData(categoryTitle: "All", size: 0))
    private let categories = BehaviorSubject<[CategoryData]>(value: [])
    private let state = BehaviorSubject<State>(value: .choseCategory)
    private let treasures = BehaviorSubject<[TreasureData]>(value: [])
    private let images = BehaviorSubject<[String]?>(value: nil)
    private let navEvent = PublishSubject<NavigationEvent>()
    
    init(treasureAPI: TreasuresAPI) {
        self.treasureAPI = treasureAPI
        self.categories.onNext(categoriesList)
    }
    
    func markerSelected() {
        state.onNext(.pickupTreasure)
    }
    
    func markerDeselected() {
        state.onNext(.choseCategory)
    }
    
    func getTreasureForId(_ id: CLongLong) {
        do {
            let allTreasures = try treasures.value()
            allTreasures.forEach { (treasure) in
                if treasure.id == id {
                    selectedTreasure.onNext(treasure)
                }
            }
        } catch let error {
            print(error)
        }
        
    }

    public func getSelectedTreasure() -> TreasureData?
    {
        do {
            return try selectedTreasure.value()
        }
        catch
        {
            return nil
        }
    }
    
    public func getSelectedImages() -> [String]?
    {
        do {
            return try images.value()
        }
        catch
        {
            return nil
        }
    }
    
    func getTreasureRequest(_ id: CLongLong) {
        treasureAPI.getTreasure(id) { (treasureData, error) in
            guard let treasure = treasureData?.data else {return}
            self.selectedTreasure.onNext(treasure)
        }
    }
    
    func unselectTreasure() {
        self.selectedTreasure.onNext(nil)
    }
    
    func getTreasures(latitude: CLong, longitude: CLong, categoryIndex: Int = 0) {
        let selectedCategory = self.categoriesList[categoryIndex]
        self.category.onNext(CategoryData(categoryTitle: selectedCategory.categoryTitle, size: selectedCategory.size))
//        self.selectedTreasure.onNext(nil)
        task?.cancel()
        task = DispatchWorkItem {
            self.treasureAPI.getTreasures(latitude: latitude, longitude: longitude) { (treasures, error) in
                guard let treasures = treasures else {return}
                let treasuresResult = treasures.data.filter { treasureData in
                    guard categoryIndex != 0 else {return true}
                    return treasureData.categoty == self.categoriesList[categoryIndex].categoty
                }
                self.categoriesList[0] = CategoryData(categoryTitle: "All", size: treasures.data.count)
                self.categories.onNext(self.categoriesList)
                let selectedCategory = self.categoriesList[categoryIndex]
                for category in self.categoriesList
                {
                    if category.categoryTitle != "All" {
                        
                        if let i = self.categoriesList.firstIndex(of: category) {
                            let categoryResultsSize = treasures.data.filter { treasureData in
                                return treasureData.categoty == category.categoty
                            }.count
                            self.categoriesList[i] = CategoryData(categoryTitle: category.categoryTitle, size: categoryResultsSize)
                        }
                    }
                    
                    self.category.onNext(CategoryData(categoryTitle: selectedCategory.categoryTitle, size: selectedCategory.size))
                    self.treasures.onNext(treasuresResult)
                }
            }
        }
        DispatchQueue.global(qos: .default).asyncAfter(deadline: DispatchTime.now() + 0.3, execute: self.task!)
    }
    
    func getImages(_ id: CLongLong) {
        treasureAPI.getTreasureImages(id) { (imgsData, error) in
            guard let urls = imgsData?.data else {return}
            self.images.onNext(urls)
        }
    }
    
    func pickUpTreasure(_ id: CLongLong) {
        treasureAPI.pickupTreasure(id) { (isPicked, error) in
            if (isPicked) {
                self.navEvent.onNext(.treasurePicked)
            }
        }
    }
}
