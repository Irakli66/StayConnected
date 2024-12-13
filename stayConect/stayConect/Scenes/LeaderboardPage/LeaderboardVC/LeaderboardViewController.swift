//
//  LeaderboardViewController.swift
//  stayConect
//
//  Created by irakli kharshiladze on 29.11.24.
//

import UIKit

final class LeaderboardViewController: UIViewController {
    private let leaderboardViewModel = LeaderboardViewModel()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Leaderboard"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let podiumView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: AppColors.primaryColor.rawValue)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let firstPlaceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: AppColors.primaryColor.rawValue)
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let leaderboardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: AppColors.secondaryColor.rawValue)
        view.layer.cornerRadius = 13
        return view
    }()
    
    private let rankingTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let firstPlace = WinnerStackView()
    private let secondPlace = WinnerStackView()
    private let thirdPlace = WinnerStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        Task {
            do {
                try await leaderboardViewModel.getUserRankings()
                rankingTableView.reloadData()
                let topThree = leaderboardViewModel.getTopThree()
                firstPlace.update(with: topThree[0].username, email: topThree[0].email, score: topThree[0].score, ranking: 1, imageUrl: "https://avatars.githubusercontent.com/u/1")
                secondPlace.update(with: topThree[1].username, email: topThree[1].email, score: topThree[1].score, ranking: 2, imageUrl: "https://avatars.githubusercontent.com/u/4")
                thirdPlace.update(with: topThree[2].username, email: topThree[2].email, score: topThree[2].score, ranking: 3, imageUrl: "https://avatars.githubusercontent.com/u/6")
            } catch {
                print("Error fetching rankings: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupUI() {
        setupPageTitle()
        setupPodium()
        setupLeaderboardView()
        setupRankingTableView()
    }
    
    private func setupPageTitle() {
        view.addSubview(pageTitle)
        
        NSLayoutConstraint.activate([
            pageTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            pageTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 75)
        ])
    }
    
    private func setupPodium() {
        [podiumView, firstPlaceView, firstPlace, secondPlace, thirdPlace].forEach{ view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            podiumView.leadingAnchor.constraint(equalTo: pageTitle.leadingAnchor, constant: 15),
            podiumView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            podiumView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 120),
            podiumView.heightAnchor.constraint(equalToConstant: 100),
            
            firstPlaceView.bottomAnchor.constraint(equalTo: podiumView.bottomAnchor),
            firstPlaceView.centerXAnchor.constraint(equalTo: podiumView.centerXAnchor),
            firstPlaceView.heightAnchor.constraint(equalToConstant: 150),
            firstPlaceView.widthAnchor.constraint(equalToConstant: 110),
            
            secondPlace.leadingAnchor.constraint(equalTo: podiumView.leadingAnchor, constant: 20),
            secondPlace.bottomAnchor.constraint(equalTo: podiumView.bottomAnchor, constant: -20),
            thirdPlace.trailingAnchor.constraint(equalTo: podiumView.trailingAnchor, constant: -20),
            thirdPlace.bottomAnchor.constraint(equalTo: podiumView.bottomAnchor, constant: -20),
            
            firstPlace.centerXAnchor.constraint(equalTo: firstPlaceView.centerXAnchor),
            firstPlace.bottomAnchor.constraint(equalTo: firstPlaceView.bottomAnchor, constant: -40),
        ])
    }
    
    private func setupLeaderboardView() {
        view.addSubview(leaderboardView)
        
        NSLayoutConstraint.activate([
            leaderboardView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            leaderboardView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            leaderboardView.topAnchor.constraint(equalTo: podiumView.bottomAnchor, constant: 10),
            leaderboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
        ])
    }
    
    private func setupRankingTableView() {
        leaderboardView.addSubview(rankingTableView)
        
        NSLayoutConstraint.activate([
            rankingTableView.leftAnchor.constraint(equalTo: leaderboardView.leftAnchor, constant: 15),
            rankingTableView.rightAnchor.constraint(equalTo: leaderboardView.rightAnchor, constant: -15),
            rankingTableView.bottomAnchor.constraint(equalTo: leaderboardView.bottomAnchor),
            rankingTableView.topAnchor.constraint(equalTo: leaderboardView.topAnchor, constant: 15),
        ])
        
        rankingTableView.dataSource = self
        rankingTableView.delegate = self
        rankingTableView.register(RankingTableViewCell.self, forCellReuseIdentifier: "RankingTableViewCell")
    }
    
}

extension LeaderboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        leaderboardViewModel.getRemainingUsersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RankingTableViewCell", for: indexPath) as? RankingTableViewCell else { return UITableViewCell() }
        
        let currentIndex = indexPath.row
        let currentUser = leaderboardViewModel.getRemainingUser(at: currentIndex)
        
        cell.configureCell(with: currentUser)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        85
    }
}
