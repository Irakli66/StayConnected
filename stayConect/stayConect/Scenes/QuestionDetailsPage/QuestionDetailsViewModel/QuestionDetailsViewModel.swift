//
//  QuestionDetailsViewModel.swift
//  stayConect
//
//  Created by irakli kharshiladze on 05.12.24.
//
import Foundation
import CustomDateFormatter

final class QuestionDetailsViewModel {
    private let authRequestHandler: AuthRequestHandlerProtocol
    private let dateFormatter: CustomDateFormatter
    private let keychainManager:  KeyChainManagerProtocol
    var question: QuestionDetail?
    
    init(authRequestHandler: AuthRequestHandlerProtocol = AuthRequestHandler(), dateFormatter: CustomDateFormatter = CustomDateFormatter(), keychainManager: KeyChainManagerProtocol = KeyChainManager()) {
        self.authRequestHandler = authRequestHandler
        self.dateFormatter = dateFormatter
        self.keychainManager = keychainManager
    }
    
    func fetchQuestion(with id: Int) async throws {
        let response: QuestionDetail = try await authRequestHandler.sendRequest(urlString: "https://db.idk.ge/stay_connected/questions/\(id)/", method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        question = response
    }
    
    func formatDate(date: String, inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", outputFormat: String = "MM/dd/yyyy 'at' h:mm") -> String {
        return dateFormatter.formattedDate(from: date, inputFormat: inputFormat, outputFormat: outputFormat)
    }
    
    func getAnswersCount() -> Int {
        question?.answers.count ?? 0
    }
    
    func getAnswer(at index: Int) -> Answer? {
        guard let answers = question?.answers, index >= 0, index < answers.count else {
            return nil
        }
        return answers[index]
    }
    
    func addAnswer(questionId: Int, content: String) async throws {
        let url: String = "https://db.idk.ge/stay_connected/answers/"
        
        let addQuestionBody = AddQuestionBody(question: questionId, content: content)
        
        guard let bodyData = try? JSONEncoder().encode(addQuestionBody) else {
            throw AddAnswerError.wrongBodyData
        }
        
        let _: AddQuestionBody = try await authRequestHandler.sendRequest(urlString: url, method: .post, headers: nil, body: bodyData, decoder: JSONDecoder())
    }
    
    func acceptAnswer(with id: Int) async throws {
        let url: String = "https://db.idk.ge/stay_connected/answers/\(id)/accept/"
        
        let _: AnswerActionResponseModel = try await authRequestHandler.sendRequest(urlString: url, method: .patch, headers: nil, body: nil, decoder: JSONDecoder())
    }
    
    func rejectAnswer(with id: Int) async throws {
        let url: String = "https://db.idk.ge/stay_connected/answers/\(id)/reject/"
        
        let _: AnswerActionResponseModel = try await authRequestHandler.sendRequest(urlString: url, method: .patch, headers: nil, body: nil, decoder: JSONDecoder())
    }
    
    func isUserQuestionOwner(with id: Int) -> Bool {
        do {
            let userId = try keychainManager.getUserId()
            return userId == id
        } catch {
            print("Failed to retrieve user ID from keychain: \(error)")
            return false
        }
    }
}

enum AddAnswerError: Error {
    case wrongBodyData
}

enum Action {
    case accept
    case reject
}

