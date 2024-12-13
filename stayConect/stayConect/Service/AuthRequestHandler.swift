//
//  AuthRequestHandler.swift
//  stayConect
//
//  Created by irakli kharshiladze on 04.12.24.
//
import NetworkPackage
import UIKit

protocol AuthRequestHandlerProtocol {
    func sendRequest<T: Decodable>(urlString: String, method: HTTPMethod, headers: [String: String]?, body: Data?, decoder: JSONDecoder) async throws -> T
}

final class AuthRequestHandler: AuthRequestHandlerProtocol {
    private let networkService: NetworkServiceProtocol
    private let keychainManager: KeyChainManagerProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(), keychainManager: KeyChainManagerProtocol = KeyChainManager()) {
        self.networkService = networkService
        self.keychainManager = keychainManager
    }
    
    func sendRequest<T: Decodable>(urlString: String, method: HTTPMethod, headers: [String: String]? = nil, body: Data? = nil, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        var headers = headers ?? [:]
        
        if let token = try? keychainManager.getAccessToken() {
            headers["Authorization"] = "Bearer \(token)"
        } else {
            throw AuthError.accessTokenMissing
        }
        
        do {
            let response: T =  try await networkService.request(urlString: urlString, method: method, headers: headers, body: body, decoder: decoder)
            return response
        } catch  {
            try await refreshAccessToken()
            
            if let newAccessToken = try? keychainManager.getAccessToken() {
                headers["Authorization"] = "Bearer \(newAccessToken)"
                let response: T = try await networkService.request(urlString: urlString, method: method, headers: headers, body: body, decoder: decoder)
                return response
            } else {
                throw AuthError.accessTokenMissing
            }
        }
        
    }
    
    func refreshAccessToken() async throws {
        do {
            guard let refreshToken = try? keychainManager.getRefreshToken() else {
                throw AuthError.refreshTokenMissing
            }
            
            let refreshRequestBody: [String: String] = ["refresh": refreshToken]
            guard let bodyData = try? JSONEncoder().encode(refreshRequestBody) else {
                throw AuthError.invalidRequestBody
            }
            
            let response: TokenResponse = try await networkService.request(
                urlString: "https://db.idk.ge/user/api/token/refresh/",
                method: .post,
                headers: ["Content-Type": "application/json"],
                body: bodyData,
                decoder: JSONDecoder()
            )
            
            try keychainManager.storeAccessToken(accessToken: response.access)
        } catch {
            try keychainManager.clearTokens()
            logoutUser()
            throw AuthError.tokenRefreshFailed
        }
    }
    
    private func logoutUser() {
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }) else {
            print("Failed to retrieve the active window for logout")
            return
        }
        
        let loginVC = LoginPageViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        window.rootViewController = navigationController
        
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
}

enum AuthError: Error {
    case accessTokenMissing
    case refreshTokenMissing
    case invalidRequestBody
    case tokenRefreshFailed
}
