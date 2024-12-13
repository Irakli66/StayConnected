//
//  QuestionDetailModel.swift
//  stayConect
//
//  Created by irakli kharshiladze on 05.12.24.
//

struct QuestionDetail: Codable {
    let id: Int
    let author: Int
    let authorUsername: String
    let title: String
    let content: String
    let createdAt: String
    let tags: [Tag]
    let answers: [Answer]
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case authorUsername = "author_username"
        case title
        case content
        case createdAt = "created_at"
        case tags
        case answers
    }
}

struct Answer: Codable {
    let id: Int
    let author: Int
    let authorUsername: String
    let question: Int
    let content: String
    let createdAt: String
    let isAccepted: Bool
    let likes: Int?
    let dislikes: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case authorUsername = "author_username"
        case question
        case content
        case createdAt = "created_at"
        case isAccepted = "is_accepted"
        case likes
        case dislikes
    }
}
