//
//  LeaderboardModel.swift
//  stayConect
//
//  Created by irakli kharshiladze on 01.12.24.
//
import Foundation

struct UserDataResponse: Codable {
    let data: [User]
}

struct User: Codable {
    let id: Int
    let fullname: String
    let email: String
    let profileImage: String
    let score: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullname
        case email
        case profileImage = "profile_image"
        case score
    }
}

struct LeaderboardModel: Codable {
    let username: String
    let email: String
    let score: Int
}
