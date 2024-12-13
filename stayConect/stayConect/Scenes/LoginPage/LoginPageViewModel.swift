//
//  LoginPageViewModel.swift
//  stayConect
//
//  Created by irakli kharshiladze on 28.11.24.
//
import Foundation
import NetworkPackage

final class LoginPageViewModel {
    private let networkService: NetworkServiceProtocol
    private let keyChainManager: KeyChainManagerProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(), keyChainManager: KeyChainManagerProtocol = KeyChainManager()) {
        self.networkService = networkService
        self.keyChainManager = keyChainManager
    }
    
    func login(username: String, password: String) async throws {
        guard !username.isEmpty else {
            throw LoginPageError.isValidUsername
        }
        guard !password.isEmpty else {
            throw LoginPageError.invalidPassword
        }
        
        let loginRequestBody: [String: String] = ["username": username.lowercased(), "password": password]
        guard let bodyData = try? JSONEncoder().encode(loginRequestBody) else {
            throw LoginPageError.wrongBodyData
        }
        
        do {
            let response: UserLoginResponse = try await networkService.request(
                urlString: "https://db.idk.ge/user/api/token/",
                method: .post,
                headers: ["Content-Type": "application/json"],
                body: bodyData,
                decoder: JSONDecoder()
            )
            try keyChainManager.storeTokens(accessToken: response.access, refreshToken: response.refresh ?? "")
            try keyChainManager.storeUserId(userId: response.userId)
        } catch {
            throw error 
        }
    }
}

enum LoginPageError: Error {
    case isValidUsername
    case invalidPassword
    case wrongBodyData
}

