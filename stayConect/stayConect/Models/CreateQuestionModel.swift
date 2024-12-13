//
//  CreateQuestionModel.swift
//  stayConect
//
//  Created by irakli kharshiladze on 04.12.24.
//
import Foundation

struct CreateQuestionBody: Codable {
    let title: String
    let content: String
    let tag: [Int]?
}
