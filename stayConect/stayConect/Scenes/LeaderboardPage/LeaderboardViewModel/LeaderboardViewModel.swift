//
//  LeaderboardViewModel.swift
//  stayConect
//
//  Created by irakli kharshiladze on 29.11.24.
//
import Foundation
import NetworkPackage

final class LeaderboardViewModel {
    let networkService: NetworkServiceProtocol
    private var userRankings: [LeaderboardModel] = []
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getUserRankings() async throws {
        let leaderboardResponse: [LeaderboardModel] = try await networkService.request(urlString: "https://db.idk.ge/user/users/", method: .get, headers: nil, body: nil, decoder: JSONDecoder())
        
        userRankings = leaderboardResponse
    }
    
    func getTopThree() -> [LeaderboardModel] {
        Array(userRankings.prefix(3))
    }
    
    func getRemainingUsers() -> [LeaderboardModel] {
        Array(userRankings.dropFirst(3))
    }
    
    func getRemainingUsersCount() -> Int {
        max(0, userRankings.count - 3)
    }
    
    func getRemainingUser(at index: Int) -> LeaderboardModel {
        getRemainingUsers()[index]
    }
    
}
