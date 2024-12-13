//
//  QuestionViewModel.swift
//  stayConect
//
//  Created by Nkhorbaladze on 02.12.24.
//


import Foundation
import NetworkPackage

class QuestionViewModel: ObservableObject {
    private var questions: [Question] = []
    private let authRequestHandler: AuthRequestHandlerProtocol
    private var errorMessage: String?
    private let networkService: NetworkServiceProtocol
    private var currentQuestion: Question?
    private let keyChainManager: KeyChainManagerProtocol
    var currentPage: Int = 1
    var questionsChanged: (() -> Void)?
    
    init(networkService: NetworkServiceProtocol = NetworkService(), keyChainManager: KeyChainManagerProtocol = KeyChainManager(), authRequestHandler: AuthRequestHandlerProtocol = AuthRequestHandler()) {
        self.networkService = networkService
        self.keyChainManager = keyChainManager
        self.authRequestHandler = authRequestHandler
        self.questionsChanged?()
    }
    
    func fetchQuestions(page: Int = 1, pageSize: Int = 10, tagId: Int = 0, query: String? = "", userId: Int? = nil) async throws {
        var url = "https://db.idk.ge/stay_connected/questions/?page=\(page)&page_size=\(pageSize)"
        
        if let query = query, !query.isEmpty {
            url += "&search=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        
        let response: PaginatedQuestions = try await authRequestHandler.sendRequest(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        
        currentPage = page
        if page == 1 {
            questions = response.results
        } else {
            questions.append(contentsOf: response.results)
        }
        questionsChanged?()
    }
    
    func fetchPersonalQuestions(page: Int = 1, pageSize: Int = 10, tagId: Int = 0, query: String? = "") async throws {
        let userId: Int
        do {
            userId = try keyChainManager.getUserId()
        } catch {
            throw error
        }
        
        guard userId != 0 else {
            throw NSError(domain: "InvalidUserId", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve valid user ID from Keychain."])
        }
        
        let url = "https://db.idk.ge/stay_connected/questions/?user_id=\(userId)&page=\(page)&page_size=\(pageSize)"
        
        let response: PaginatedQuestions = try await authRequestHandler.sendRequest(urlString: url, method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        
        questions = response.results
    }
    
    
    var isEmpty: Bool {
        return getQuestionsCount() == 0
    }
    
    func getQuestionsCount() -> Int {
        return questions.count
    }
    
    func getQuestions(_ at: Int) -> Question {
        return questions[at]
    }
    
    func getAllQuestions() -> [Question] {
        return questions
    }
    
    func updateQuestions(_ newQuestions: [Question]) {
        self.questions = newQuestions
    }
}
