//
//  Router.swift
//  stayConect
//
//  Created by irakli kharshiladze on 04.12.24.
//

import UIKit

final class Router: UIViewController {
    private let keychainManager: KeyChainManagerProtocol
    
    init(keychainManager: KeyChainManagerProtocol = KeyChainManager()) {
        self.keychainManager = keychainManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserAuthentication()
    }
    
    private func checkUserAuthentication() {
        do {
            let isRefreshTokenPresent: Bool = (try? keychainManager.getRefreshToken())?.isEmpty == false
            if isRefreshTokenPresent {
                setRootViewController(TabBarController())
            } else {
                setRootViewController(LoginPageViewController(), hideNavBar: true)
            }
        } catch {
            print("Error fetching refresh token: \(error.localizedDescription)")
            setRootViewController(LoginPageViewController(), hideNavBar: true)
        }
    }
    
    private func setRootViewController(_ viewController: UIViewController, hideNavBar: Bool = false) {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.isNavigationBarHidden = hideNavBar
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
    
}

