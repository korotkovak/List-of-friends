//
//  SceneDelegate.swift
//  List of friends
//
//  Created by Kristina Korotkova on 17/03/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let viewController = ModuleBuilder.shared.homeModule
        let navigationController = UINavigationController(
            rootViewController: viewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
