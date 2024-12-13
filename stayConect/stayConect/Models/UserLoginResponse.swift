//
//  UserLoginResponse.swift
//  stayConect
//
//  Created by irakli kharshiladze on 04.12.24.
//

struct UserLoginResponse: Codable {
    let access: String
    let refresh: String?
    let userId: Int

    enum CodingKeys: String, CodingKey {
        case access
        case refresh
        case userId = "user_id"
    }
}
