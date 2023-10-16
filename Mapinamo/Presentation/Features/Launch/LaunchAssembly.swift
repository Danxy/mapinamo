//
//  LaunchAssembly.swift
//  Mapinamo
//
//  Created by Daniel on 2023-10-12.
//

import Foundation

@MainActor
public enum LaunchAssembly {
    public static func assemble(
        navigation: LaunchNavigation?
    ) -> LaunchView  {
//        let authService: AuthServiceProtocol = AuthService()
//        let worker: StartWorkerProtocol = StartWorker(authService: authService)
//        let viewModel = LaunchViewModel(worker: worker, navigation: navigation)
        let viewModel = LaunchViewModel(navigation as! LauchCoordinator)
        return LaunchView(viewModel: viewModel)
    }
}
