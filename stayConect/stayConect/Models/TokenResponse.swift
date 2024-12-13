//
//  TokenResponse.swift
//  stayConect
//
//  Created by irakli kharshiladze on 03.12.24.
//

struct TokenResponse: Decodable {
    let access: String
    let refresh: String?
}
