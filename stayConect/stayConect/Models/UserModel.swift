//
//  UserModel.swift
//  stayConect
//
//  Created by irakli kharshiladze on 01.12.24.
//

struct UserProfile: Codable {
    let id: Int
    let fullname: String
    let email: String
    let profileImage: String
    let score: Int
    let answeredQuestions: [AnsweredQuestion]
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullname
        case email
        case profileImage = "profile_image"
        case score
        case answeredQuestions = "answered_questions"
    }
}

struct AnsweredQuestion: Codable {
    let id: Int
    let subject: String
    let question: String
}

struct ProfileUserData: Codable {
    let id: Int
    let username: String
    let email: String
    let score: Int
    let answerCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case score
        case answerCount = "answer_count"
    }
}
