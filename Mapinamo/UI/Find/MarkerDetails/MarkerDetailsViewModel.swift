//
//  MarkerDetailsViewModel.swift
//  Mapinamo
//
//  Created by Daniel on 2023-10-17.
//  Copyright © 2023 Db. All rights reserved.
//

import Foundation
import RxSwift

class MarkerDetailsViewModel {
    
    private var treasureAPI: TreasuresAPI
    
    var selectedTreasureObservable: Observable<TreasureData?> {
        return selectedTreasure.asObservable()
    }
    
    var imagesObservable: Observable<[String]?> {
        return images.asObservable()
    }
    
    private var selectedTreasure = BehaviorSubject<TreasureData?>(value: nil)
    private let images = BehaviorSubject<[String]?>(value: nil)
    
    init(treasureAPI: TreasuresAPI,
         selectedTreasure: TreasureData,
         selectedImages: [String]) {
        self.treasureAPI = treasureAPI
        self.selectedTreasure.onNext(selectedTreasure)
        self.images.onNext(selectedImages)
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
    
    public func getSelectedImage() -> [String]?
    {
        do {
            return try images.value()
        }
        catch
        {
            return nil
        }
    }
    
}
