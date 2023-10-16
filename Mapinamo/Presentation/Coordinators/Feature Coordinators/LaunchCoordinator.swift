//
//  LaunchCoordinator.swift
//  Mapinamo
//
//  Created by Daniel on 2023-10-12.
//

import Foundation
import SwiftUI
import UIKit

@MainActor
class LauchCoordinator: CoordinatorProtocol, LaunchNavigation {
    
    var window: UIWindow
    
    private var lauchViewController: UIViewController?
    
    init(_ window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let lauchView = LaunchAssembly.assemble(navigation: self)
        let lauchViewController = UIHostingController(rootView: lauchView)
        window.rootViewController = lauchViewController
        self.lauchViewController = lauchViewController
        window.makeKeyAndVisible()
    }
    
    func performRoute(_ route: LaunchViewModel.Route) {
        switch route {
        case .treasureDetails(let _):
            print("treasure details route")
        case .main:
            print("main route")
        }
    }
    
}
