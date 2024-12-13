//
//  WinnerStackView.swift
//  stayConect
//
//  Created by irakli kharshiladze on 01.12.24.
//
import UIKit

final class WinnerStackView: UIStackView {
    private let imageView: UIImageView
    private let rankingView: UIView
    private let rankingLabel: UILabel
    private let nameLabel: UILabel
    private let scoreLabel: UILabel
    private let emailLabel: UILabel
    
    init() {
        imageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        rankingView = UIView()
        rankingLabel = UILabel()
        nameLabel = UILabel()
        scoreLabel = UILabel()
        emailLabel = UILabel()
        
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.spacing = 5
        self.alignment = .center
        
        setupImageView()
        setupRankingView()
        setupLabels()
        addSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.tintColor = UIColor.systemGray4
        imageView.clipsToBounds = true
    }
    
    private func setupRankingView() {
        rankingView.translatesAutoresizingMaskIntoConstraints = false
        rankingView.heightAnchor.constraint(equalTo: rankingView.widthAnchor).isActive = true
        rankingView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        rankingView.layer.cornerRadius = 5
        rankingView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        
        rankingLabel.translatesAutoresizingMaskIntoConstraints = false
        rankingLabel.textColor = .white
        rankingLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        rankingView.addSubview(rankingLabel)
        
        rankingLabel.centerXAnchor.constraint(equalTo: rankingView.centerXAnchor).isActive = true
        rankingLabel.centerYAnchor.constraint(equalTo: rankingView.centerYAnchor).isActive = true
    }
    
    private func setupLabels() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textColor = .white
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.textColor = UIColor(hex: "#B7B3B3")
        emailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private func addSubviews() {
        [imageView, rankingView, nameLabel, scoreLabel, emailLabel].forEach { addArrangedSubview($0) }
    }
    
    func update(with fullname: String, email: String, score: Int, ranking: Int, imageUrl: String) {
        let firstName = fullname.split(separator: " ").first.map(String.init) ?? fullname
        
        imageView.imageFrom(url: URL(string: imageUrl)!)
        nameLabel.text = firstName
        scoreLabel.text = "\(score)"
        emailLabel.text = "@\(firstName)"
        rankingLabel.text = "\(ranking)"
        rankingView.backgroundColor = UIColor(hex: ranking == 1 ? "#FFAA00" : ranking == 2 ? "#B2B2B2" : "#7B7C58")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
    }
}
