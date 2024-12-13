//
//  AnsweredQuestionsViewModel.swift
//  stayConect
//
//  Created by irakli kharshiladze on 29.11.24.
//

import Foundation
import NetworkPackage

final class AnsweredQuestionsViewModel: ObservableObject {
    private var answeredQuestions: [Question] = []
    private let networkService: NetworkServiceProtocol
    private let authRequestHandler: AuthRequestHandlerProtocol
    var currentPage: Int = 1
    var answeredQuesitonsChanged: (() -> Void)?
    
    init(networkService: NetworkServiceProtocol = NetworkService(), authRequestHandler: AuthRequestHandlerProtocol = AuthRequestHandler()) {
        self.networkService = networkService
        self.authRequestHandler = authRequestHandler
    }
    
    func fetchAnsweredQuestions(page: Int = 1, pageSize: Int = 10, tagId: Int = 0, query: String? = "", userId: Int? = nil) async throws {
        var url = "https://db.idk.ge/stay_connected/questions/answered_questions/?page=\(page)&page_size=10"
        
        if let query = query, !query.isEmpty {
            url += "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }
        
        let response: PaginatedQuestions = try await authRequestHandler.sendRequest(
            urlString: url,
            method: .get,
            headers: nil,
            body: nil,
            decoder: JSONDecoder()
        )
        
        currentPage = page
        if page == 1 {
            answeredQuestions = response.results
        } else {
            answeredQuestions.append(contentsOf: response.results)
        }
        
        answeredQuesitonsChanged?()
    }
    
    var isEmpty: Bool {
        return getQuestionsCount() == 0
    }
    
    func getQuestionsCount() -> Int {
        return answeredQuestions.count
    }
    
    func getQuestions(_ at: Int) -> Question {
        return answeredQuestions[at]
    }
    
    func getAnswersCount(_ at: Int) -> Int {
        return answeredQuestions.count
    }
    
    func updateQuestions(_ newQuestions: [Question]) {
        self.answeredQuestions = newQuestions
    }
}
