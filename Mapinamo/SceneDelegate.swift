//
//  SceneDelegate.swift
//  Mapinamo
//
//  Created by Daniel on 2023-10-12.
//

import Foundation
import SwiftUI

class SceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {
    
    var window: UIWindow?
    var navigator: CoordinatorProtocol?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("SceneDelegate is connected!")
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let navigator = LauchCoordinator(window)
        self.navigator = navigator
        self.window = window
        navigator.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
      
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
      
    }

    func sceneWillResignActive(_ scene: UIScene) {
      
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
      
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
      
    }
}
