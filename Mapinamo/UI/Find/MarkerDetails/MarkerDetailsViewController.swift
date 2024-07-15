//
//  MarkerDetailsViewController.swift
//  Mapinamo
//
//  Created by Daniel on 2023-10-17.
//  Copyright © 2023 Db. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SwiftLocation
import GoogleMaps

class MarkerDetailsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var treasureImageView: UIImageView!
    @IBOutlet weak var treasureNameLabel: UILabel!
    @IBOutlet weak var treasureDescriptionLabel: UILabel!
    @IBOutlet weak var treasureLocationLabel: UILabel!
    
    var viewModel: MarkerDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupObservers()
    }
    
    private func setupView() {
        MGeocoder.shared.result = gAddressReceived
    }
    
    private func setupObservers() {
        viewModel?.selectedTreasureObservable.subscribe(onNext: { (treasure) in
            guard let treasure = treasure else { return }
            self.treasureNameLabel.text = treasure.name
            self.treasureDescriptionLabel.text = treasure.comment
        
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(treasure.coords?.latitude ?? 1) / 100000000),
                                                  longitude: CLLocationDegrees(Double(treasure.coords?.longitude ?? 1) / 100000000))
            MGeocoder.shared.geocodeFrom(coordinates: location)
            
        }).disposed(by: disposeBag)
        
        viewModel?.imagesObservable.subscribe(onNext: { images in
            guard let images = images, let imageStr = images.first else { return }
            self.treasureImageView.sd_setImage(with: URL(string: imageStr))
        }).disposed(by: disposeBag)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func directionButtonAction(_ sender: Any) {
        self.showDirectionsPicker()
    }
    
    private func showDirectionsPicker()
    {
        guard let selectedTreasure = viewModel?.getSelectedTreasure() else {return}
        let lat = (Double(selectedTreasure.coords?.latitude ?? CLong(1.0))) / 100000000
        let long = (Double(selectedTreasure.coords?.longitude ?? CLong(1.0))) / 100000000
        let alertController = UIAlertController(title: "Show direction", message: "Please chose app", preferredStyle: .actionSheet)
        
        let appleMaps = UIAlertAction(title: "Apple Maps", style: .default) {_ in
            UIApplication.shared.open(URL(string:"http://maps.apple.com/?saddr=&daddr=\(lat),\(long)")!)
        }
        
        let googleMaps = UIAlertAction(title: "Google Maps", style: .default) {_ in
            UIApplication.shared.open(URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving")!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(appleMaps)
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            alertController.addAction(googleMaps)
        }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func gAddressReceived(place: Place?) {
        guard let place = place else { return }
        self.treasureLocationLabel.text = "\(place.city ?? "") \(place.streetAddress ?? "") \( place.streetNumber ?? "")"
    }
}
