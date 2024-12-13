//
//  TagModel.swift
//  stayConect
//
//  Created by irakli kharshiladze on 02.12.24.
//

struct TagResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Tag]
}

struct Tag: Codable {
    let id: Int
    let name: String
}
