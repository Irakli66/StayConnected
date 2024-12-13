//
//  RankingTableViewCell.swift
//  stayConect
//
//  Created by irakli kharshiladze on 01.12.24.
//

import UIKit

class RankingTableViewCell: UITableViewCell {
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = UIColor(hex: "#B7B3B3")
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .italicSystemFont(ofSize: 14)
        label.textColor = UIColor(hex: "#B7B3B3")
        return label
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 13
        self.selectionStyle = .none
        self.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(cellStackView)
        [userStackView, scoreLabel].forEach{ cellStackView.addArrangedSubview($0) }
        [fullnameLabel, emailLabel].forEach{ userStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            cellStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            cellStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    func configureCell(with user: LeaderboardModel) {
        fullnameLabel.text = user.username
        emailLabel.text = user.email
        scoreLabel.text = user.score.description
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
}
