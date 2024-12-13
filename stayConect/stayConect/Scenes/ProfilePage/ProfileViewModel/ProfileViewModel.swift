//
//  ProfileViewModel.swift
//  stayConect
//
//  Created by irakli kharshiladze on 29.11.24.
//

import Foundation
import NetworkPackage
import UIKit

final class ProfileViewModel {
    private let networkService: NetworkServiceProtocol
    private let authRequestHanlder: AuthRequestHandlerProtocol
    private let keyChainManager: KeyChainManagerProtocol
    var user: ProfileUserData?
    
    init(networkService: NetworkServiceProtocol = NetworkService(), keyChainManager: KeyChainManagerProtocol = KeyChainManager(), authRequestHanlder: AuthRequestHandlerProtocol = AuthRequestHandler()) {
        self.networkService = networkService
        self.keyChainManager = keyChainManager
        self.authRequestHanlder = authRequestHanlder
    }
    
    func fetchUserData() async throws {
        let userId = try keyChainManager.getUserId()
        let url = "https://db.idk.ge/user/users/\(userId)/"
        
        let response: ProfileUserData = try await networkService.request(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        
        user = response
    }
    
    func logout() throws {
        try keyChainManager.clearTokens()
        
        DispatchQueue.main.async {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                let loginViewController = LoginPageViewController()
                let navigationController = UINavigationController(rootViewController: loginViewController)
                
                sceneDelegate.window?.rootViewController = navigationController
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }
}
