//
//  TagViewModel.swift
//  stayConect
//
//  Created by Nkhorbaladze on 06.12.24.
//

import Foundation

final class TagViewModel: ObservableObject {
    private let authRequestHandler: AuthRequestHandlerProtocol
    private var tags: [Tag] = []
    
    init(authRequestHandler: AuthRequestHandlerProtocol = AuthRequestHandler()) {
        self.authRequestHandler = authRequestHandler
    }
    func fetchTags() async throws {
        let response: TagResponse = try await authRequestHandler.sendRequest(urlString: "https://db.idk.ge/stay_connected/tags/?page=1&page_size=10", method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        tags = response.results
    }
    
    func fetchQuestionsOnTag(page: Int = 1, pageSize: Int = 10, tagId: Int, query: String? = "", userId: Int? = nil) async throws -> PaginatedQuestions {
        var url = "https://db.idk.ge/stay_connected/questions/?page=\(page)&page_size=\(pageSize)"
        
        if tagId != 0 {
            url += "&tag_id=\(tagId)"
        }
        
        let response: PaginatedQuestions = try await authRequestHandler.sendRequest(
            urlString: url,
            method: .get,
            headers: nil,
            body: nil,
            decoder: JSONDecoder()
        )
        return response
    }
    
    func fetchAnsweredQuestionsOnTag(page: Int = 1, pageSize: Int = 10, tagId: Int, query: String? = "", userId: Int? = nil) async throws -> PaginatedQuestions {
        var url = "https://db.idk.ge/stay_connected/questions/answered_questions/?page=\(page)&page_size=\(pageSize)"
        
        if tagId != 0 {
            url += "&tag_id=\(tagId)"
        }
        
        let response: PaginatedQuestions = try await authRequestHandler.sendRequest(
            urlString: url,
            method: .get,
            headers: nil,
            body: nil,
            decoder: JSONDecoder()
        )
        return response
    }
    
    func getTags(_ at: Int) -> Tag {
        return tags[at]
    }
    
    func getTagsCount() -> Int {
        return tags.count
    }
}
