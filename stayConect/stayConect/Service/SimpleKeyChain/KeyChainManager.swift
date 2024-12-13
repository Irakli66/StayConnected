//
//  KeyChainManager.swift
//  stayConect
//
//  Created by irakli kharshiladze on 03.12.24.
//
import UIKit
import SimpleKeychain

protocol KeyChainManagerProtocol {
    func storeTokens(accessToken: String, refreshToken: String) throws
    func storeAccessToken(accessToken: String) throws
    func storeUserId(userId: Int) throws
    func getRefreshToken() throws -> String
    func getAccessToken() throws -> String
    func getUserId() throws -> Int
    func clearTokens() throws
}

final class KeyChainManager: KeyChainManagerProtocol {
    private let simpleKeychain: SimpleKeychain
    
    init(simpleKeychain: SimpleKeychain = SimpleKeychain()) {
        self.simpleKeychain = simpleKeychain
    }
    
    func storeTokens(accessToken: String, refreshToken: String) throws {
        try simpleKeychain.set(accessToken, forKey: "accessToken")
        try simpleKeychain.set(refreshToken, forKey: "refreshToken")
    }
    
    func storeAccessToken(accessToken: String) throws {
        try simpleKeychain.set(accessToken, forKey: "accessToken")
    }
    
    func storeUserId(userId: Int) throws {
        try simpleKeychain.set("\(userId)", forKey: "userId")
    }
    
    func getRefreshToken() throws -> String {
        try simpleKeychain.string(forKey: "refreshToken")
    }
    
    func getAccessToken() throws -> String {
        try simpleKeychain.string(forKey: "accessToken")
    }
    
    func getUserId() throws -> Int {
        guard let userId = try? simpleKeychain.string(forKey: "userId") else {
            return 0
        }
        
        guard let intUserId = Int(userId) else { return 0 }
        return intUserId
    }
    
    func clearTokens() throws {
        try simpleKeychain.deleteItem(forKey: "refreshToken")
        try simpleKeychain.deleteItem(forKey: "accessToken")
    }
}
