//
//  QuestionModel.swift
//  stayConect
//
//  Created by irakli kharshiladze on 05.12.24.
//

import UIKit

struct PaginatedQuestions: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Question]
}

struct Question: Codable {
    let id: Int
    let author: Int
    let authorUsername: String
    let title: String
    let content: String
    let createdAt: String
    let tags: [Tag]
    let countAnswers: Int
    let hasAcceptedAnswer: Bool
    let isMineAccepted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case authorUsername = "author_username"
        case title
        case content
        case createdAt = "created_at"
        case tags
        case countAnswers = "count_answers"
        case hasAcceptedAnswer = "has_accepted_answer"
        case isMineAccepted = "is_mine_accepted"
    }
}
