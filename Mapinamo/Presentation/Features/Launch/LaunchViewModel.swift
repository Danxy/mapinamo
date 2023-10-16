//
//  LaunchViewModel.swift
//  Mapinamo
//
//  Created by Daniel on 2023-10-12.
//

import Foundation
import Combine

@MainActor
public protocol LaunchNavigation: AnyObject {
    func performRoute(_ route: LaunchViewModel.Route)
}

@MainActor
public class LaunchViewModel: ObservableObject {
    
    public enum Route {
        case treasureDetails(_ treasureId: CLongLong?)
        case main
    }
    
    private let navigation: LaunchNavigation
    
    init(_ coordinator: LauchCoordinator) {
        self.navigation = coordinator
    }
    
    func onViewAppear() {
        Task {
            print("on view did appear")
//            let isAuthenticated = await worker.isAuthenticated()
            navigation.performRoute(.main)
        }
    }
}
