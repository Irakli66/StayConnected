//
//  SceneDelegate.swift
//  stayConect
//
//  Created by irakli kharshiladze on 28.11.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        let vc = Router()
        let mainNavigationController = UINavigationController(rootViewController: vc)
        
        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()
    }
    
}

