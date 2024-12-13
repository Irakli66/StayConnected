//
//  QuestionCell.swift
//  stayConect
//
//  Created by Nkhorbaladze on 30.11.24.
//

import UIKit

class QuestionCell: UITableViewCell {
    
    static let identifier = "QuestionCell"
    private var tagsArray: [Tag] = []
    
    enum QuestionContext {
        case home
        case answered
    }
    
    // MARK: - Elements
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var subjectName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: StayConnectFonts.interRegular.rawValue, size: 13)
        label.textColor = UIColor(hex: "3C3C43")
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: StayConnectFonts.interRegular.rawValue, size: 15)
        label.textColor = UIColor(hex: "000000")
        label.textAlignment = .left
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var tagCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        collectionView.tag = 2
        
        return collectionView
    }()
    
    private lazy var repliesCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: StayConnectFonts.interRegular.rawValue, size: 15)
        label.textColor = UIColor(hex: "A1A1A5")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var approvedCheckmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: AppIcons.approvedCheckmark.rawValue)
        
        return imageView
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "FAFAFA")
        return view
    }()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        self.selectionStyle = .none
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupSubviews() {
        contentView.addSubview(containerView)
        contentView.addSubview(separator)
        
        containerView.addSubview(subjectName)
        containerView.addSubview(questionLabel)
        containerView.addSubview(repliesCount)
        containerView.addSubview(tagCollection)
        containerView.addSubview(approvedCheckmarkImage)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -8),
            
            subjectName.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            subjectName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            repliesCount.centerYAnchor.constraint(equalTo: subjectName.centerYAnchor),
            repliesCount.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            questionLabel.topAnchor.constraint(equalTo: subjectName.bottomAnchor, constant: 4),
            questionLabel.leadingAnchor.constraint(equalTo: subjectName.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: approvedCheckmarkImage.leadingAnchor, constant: -5),
            
            approvedCheckmarkImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            approvedCheckmarkImage.topAnchor.constraint(equalTo: repliesCount.bottomAnchor, constant: 4),
            approvedCheckmarkImage.heightAnchor.constraint(equalToConstant: 20),
            approvedCheckmarkImage.widthAnchor.constraint(equalToConstant: 20),
            
            tagCollection.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 12),
            tagCollection.leadingAnchor.constraint(equalTo: subjectName.leadingAnchor),
            tagCollection.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            tagCollection.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            tagCollection.heightAnchor.constraint(equalToConstant: 25),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
    
    // MARK: - Configuration
    func configure(with question: Question, context: QuestionContext) {
        subjectName.text = question.title
        questionLabel.text = question.content
        repliesCount.text = "replies: \(question.countAnswers)"
        
        switch context {
        case .home:
            approvedCheckmarkImage.isHidden = !question.hasAcceptedAnswer
        case .answered:
            approvedCheckmarkImage.isHidden = !(question.isMineAccepted ?? false)
        }
        
        tagCollection.delegate = self
        tagCollection.dataSource = self
        tagsArray = question.tags
        
        tagCollection.reloadData()
    }
}

// MARK: - Extensions

extension QuestionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: tagsArray[indexPath.row].name)
        return cell
    }
}

extension QuestionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = tagsArray[indexPath.row].name
        label.sizeToFit()
        return CGSize(width: label.frame.width + 24, height: 24)
    }
}
