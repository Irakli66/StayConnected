//
//  AnsweredQuestionModel.swift
//  stayConect
//
//  Created by Nkhorbaladze on 04.12.24.
//

import UIKit

struct AnsweredQuestionsResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Question]
}
