//
//  AnswerCell.swift
//  stayConect
//
//  Created by Nkhorbaladze on 03.12.24.
//

import UIKit

final class AnswerCell: UITableViewCell {
    let questionDetailsViewModel = QuestionDetailsViewModel()
    
    static var identifier = "AnswerCell"
    
    // MARK: - Elements
    private lazy var userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var nameAndSurname: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: StayConnectFonts.interBold.rawValue, size: 15)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var answerDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: StayConnectFonts.nunitoRegular.rawValue, size: 12)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var answerTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 4
        label.lineBreakMode = .byTruncatingTail
        label.isUserInteractionEnabled = true
        label.textColor = .gray
        
        return label
    }()

    private lazy var acceptedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Accepted"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(named: AppColors.primaryColor.rawValue)
        
        return label
    }()
    
    private lazy var acceptedCheckmark: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark")
        imageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        imageView.tintColor = UIColor(named: AppColors.primaryColor.rawValue)
        
        return imageView
    }()
    
    private lazy var acceptedContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.contentView.backgroundColor = highlighted ? .clear : .white
    }
    
    private func setupSubviews() {
        contentView.addSubview(userProfileImage)
        contentView.addSubview(nameAndSurname)
        contentView.addSubview(answerDate)
        contentView.addSubview(answerTextLabel)
        acceptedContainer.addSubview(acceptedLabel)
        acceptedContainer.addSubview(acceptedCheckmark)
        contentView.addSubview(acceptedContainer)
        
        NSLayoutConstraint.activate([
            userProfileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userProfileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            userProfileImage.widthAnchor.constraint(equalToConstant: 40),
            userProfileImage.heightAnchor.constraint(equalToConstant: 40),
            
            nameAndSurname.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameAndSurname.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 10),
            nameAndSurname.trailingAnchor.constraint(lessThanOrEqualTo: acceptedContainer.leadingAnchor, constant: -10),
            
            answerDate.topAnchor.constraint(equalTo: nameAndSurname.bottomAnchor, constant: 3),
            answerDate.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 10),
            answerDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            
            answerTextLabel.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 3),
            answerTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            answerTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            answerTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            
            acceptedContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            acceptedContainer.centerYAnchor.constraint(equalTo: nameAndSurname.centerYAnchor),
            acceptedContainer.heightAnchor.constraint(equalToConstant: 20),
            
            acceptedLabel.leadingAnchor.constraint(equalTo: acceptedContainer.leadingAnchor),
            acceptedLabel.centerYAnchor.constraint(equalTo: acceptedContainer.centerYAnchor),
            
            acceptedCheckmark.leadingAnchor.constraint(equalTo: acceptedLabel.trailingAnchor, constant: 5),
            acceptedCheckmark.centerYAnchor.constraint(equalTo: acceptedLabel.centerYAnchor),
            acceptedCheckmark.trailingAnchor.constraint(equalTo: acceptedContainer.trailingAnchor)
        ])
    }
    
    // MARK: - Configuration
    func configure(with answer: Answer, isExpanded: Bool) {
        userProfileImage.imageFrom(url: URL(string: "https://avatars.githubusercontent.com/u/87134996")!)
        userProfileImage.layer.cornerRadius = 20
        userProfileImage.layer.masksToBounds = true
        nameAndSurname.text = "\(answer.authorUsername)"
        let createdAt = questionDetailsViewModel.formatDate(date: answer.createdAt)

        answerDate.text = createdAt
        
        if isExpanded {
            answerTextLabel.numberOfLines = 0
            answerTextLabel.attributedText = NSAttributedString(string: answer.content)
        } else {
            answerTextLabel.numberOfLines = 4
            answerTextLabel.attributedText = getTruncatedText(answer.content)
        }
        
        acceptedContainer.isHidden = !answer.isAccepted
    }
    
    
    private func getTruncatedText(_ text: String) -> NSAttributedString {
        if text.count > 150 {
            let truncated = String(text.prefix(150))
            let fullText = "\(truncated)...see more"
            
            let attributedText = NSMutableAttributedString(string: fullText)
            
            if let range = fullText.range(of: "...see more") {
                let nsRange = NSRange(range, in: fullText)
                attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
                attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: nsRange)
            }
            
            return attributedText
        }
        
        return NSAttributedString(string: text)
    }

    
}
