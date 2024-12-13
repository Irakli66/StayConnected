//
//  CreateQuestionViewModel.swift
//  stayConect
//
//  Created by irakli kharshiladze on 29.11.24.
//
import Foundation
import NetworkPackage

final class CreateQuestionViewModel {
    private let networkService: NetworkServiceProtocol
    private let authRequestHandler: AuthRequestHandlerProtocol
    private var tags: [Tag] = []
    
    init(networkService: NetworkServiceProtocol = NetworkService(), authenticationRequestHandler: AuthRequestHandlerProtocol = AuthRequestHandler()) {
        self.networkService = networkService
        self.authRequestHandler = authenticationRequestHandler
    }
    
    func fetchTags() async throws {
        let response: TagResponse = try await authRequestHandler.sendRequest(urlString: "https://db.idk.ge/stay_connected/tags/?page=1&page_size=10", method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        tags = response.results
    }
    
    func addQuestion(title: String, content: String, tags: [Tag]) async throws {
        let tagsId = tags.map { $0.id }
        
        let createQuestionBody = CreateQuestionBody(title: title, content: content, tag: tagsId)

        guard let bodyData = try? JSONEncoder().encode(createQuestionBody) else {
            throw LoginPageError.wrongBodyData
        }
        
        let _: CreateQuestionBody  = try await authRequestHandler.sendRequest(urlString: "https://db.idk.ge/stay_connected/questions/", method: .post, headers: nil, body: bodyData, decoder: JSONDecoder())
    }
    
    func getTagsCount() -> Int {
        tags.count
    }
    
    func getTag(at index: Int) -> Tag {
        tags[index]
    }
}
