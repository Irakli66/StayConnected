//
//  ProfileViewController.swift
//  stayConect
//
//  Created by irakli kharshiladze on 29.11.24.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let profilePageViewModel = ProfileViewModel()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Profile"
        label.font = .systemFont(ofSize: .init(20), weight: .bold)
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(hex: "#5E6366")
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameAndEmailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(hex: "#5E6366")
        return label
    }()
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Information".uppercased()
        label.font = .systemFont(ofSize: .init(15), weight: .semibold)
        label.textColor = UIColor(hex: "#5E6366")
        return label
    }()
    
    private let scoreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let answeredQuestionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let logoutView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: AppIcons.logoutIcon.rawValue)
        return imageView
    }()
    
    lazy var scoreValue = createLabel(text: "", textColor: "#5E6366")
    lazy var answeredQuestionsValue = createLabel(text: "", textColor: "#5E6366")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        Task {
            do{
                try await profilePageViewModel.fetchUserData()
                updateUI()
            } catch {
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupUI() {
        setupPageTitleLabel()
        setupProfileImageView()
        setupNameAndEmailStackView()
        setupInformation()
    }
    
    private func updateUI() {
        guard let user = profilePageViewModel.user else { return }
        profileImageView.imageFrom(url: URL(string: "https://avatars.githubusercontent.com/u/87134996")!)
        emailLabel.text = user.email
        nameLabel.text = user.username
        scoreValue.text = "\(user.score)"
        answeredQuestionsValue.text = "\(user.answerCount)"
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.masksToBounds = true
    }
    
    private func setupPageTitleLabel() {
        view.addSubview(pageTitle)
        
        NSLayoutConstraint.activate([
            pageTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            pageTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 75)
        ])
    }
    
    private func setupProfileImageView() {
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 25),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupNameAndEmailStackView() {
        view.addSubview(nameAndEmailStackView)
        [nameLabel, emailLabel].forEach{ nameAndEmailStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            nameAndEmailStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            nameAndEmailStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            nameAndEmailStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30)
        ])
    }
    
    private func setupInformation() {
        view.addSubview(informationLabel)
        
        let scoreTitle = createLabel(text: "Score")
        let divider1 = createDivider()
        let answeredQuestionsTitle = createLabel(text: "Answered Questions")
        let divider2 = createDivider()
        let logoutTitle = createLabel(text: "Log out")
        let divider3 = createDivider()
        
        [scoreTitle, scoreValue].forEach { scoreStackView.addArrangedSubview($0) }
        [answeredQuestionsTitle, answeredQuestionsValue].forEach { answeredQuestionsStackView.addArrangedSubview($0) }
        [logoutImageView, logoutTitle].forEach { logoutView.addSubview($0) }
        
        [scoreStackView, answeredQuestionsStackView, logoutView, divider1, divider2, divider3].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            informationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            informationLabel.topAnchor.constraint(equalTo: nameAndEmailStackView.bottomAnchor, constant: 60),
            
            scoreStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            scoreStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            scoreStackView.topAnchor.constraint(equalTo: informationLabel.bottomAnchor, constant:  20),
            scoreStackView.heightAnchor.constraint(equalToConstant: 50),
            divider1.leadingAnchor.constraint(equalTo: scoreStackView.leadingAnchor),
            divider1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            divider1.topAnchor.constraint(equalTo: scoreStackView.bottomAnchor, constant: 5),
            
            answeredQuestionsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            answeredQuestionsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            answeredQuestionsStackView.topAnchor.constraint(equalTo: scoreStackView.bottomAnchor, constant: 25),
            answeredQuestionsStackView.heightAnchor.constraint(equalToConstant: 50),
            divider2.leadingAnchor.constraint(equalTo: answeredQuestionsStackView.leadingAnchor),
            divider2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            divider2.topAnchor.constraint(equalTo: answeredQuestionsStackView.bottomAnchor, constant: 5),
            
            logoutView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            logoutView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            logoutView.heightAnchor.constraint(equalToConstant: 50),
            logoutView.topAnchor.constraint(equalTo: answeredQuestionsStackView.bottomAnchor, constant: 25),
            
            logoutImageView.leadingAnchor.constraint(equalTo: logoutView.leadingAnchor),
            logoutImageView.centerYAnchor.constraint(equalTo: logoutView.centerYAnchor),
            logoutTitle.leadingAnchor.constraint(equalTo: logoutImageView.trailingAnchor, constant: 10),
            logoutTitle.centerYAnchor.constraint(equalTo: logoutImageView.centerYAnchor),
            divider3.leadingAnchor.constraint(equalTo: logoutView.leadingAnchor),
            divider3.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            divider3.topAnchor.constraint(equalTo: logoutView.bottomAnchor, constant: 5),
        ])
        
        answeredQuestionsStackView.isUserInteractionEnabled = true
        logoutView.isUserInteractionEnabled = true
        
        let answeredQuestionsTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAnsweredQuestionsTap(_:)))
        answeredQuestionsStackView.addGestureRecognizer(answeredQuestionsTapGesture)
        
        let logoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLogoutTap(_:)))
        logoutView.addGestureRecognizer(logoutTapGesture)
    }
    
    private func createLabel(text: String, textColor: String = "#000000") -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(hex: textColor)
        label.textAlignment = .center
        label.text = text
        return label
    }
    
    private func createDivider() -> UIView {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = UIColor(hex: "#CCCCCC")
        divider.layer.shadowColor = UIColor.black.cgColor
        divider.layer.shadowOpacity = 0.1
        divider.layer.shadowOffset = CGSize(width: 0, height: 1)
        divider.layer.shadowRadius = 2
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return divider
    }
    
    @objc private func handleAnsweredQuestionsTap(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(AnsweredQuestionsViewController(), animated: true)
    }
    
    @objc private func handleLogoutTap(_ sender: UITapGestureRecognizer) {
        do {
            try profilePageViewModel.logout()
        } catch {
            print("Logout failed with error: \(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        Task {
            do{
                try await profilePageViewModel.fetchUserData()
                updateUI()
            } catch {
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }
}
