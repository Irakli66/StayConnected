//
//  TagCollectionViewCell.swift
//  stayConect
//
//  Created by irakli kharshiladze on 02.12.24.
//

import UIKit

final class TagCollectionViewCell: UICollectionViewCell {
    private let tagView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: AppColors.secondaryColor.rawValue)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let tagNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: AppColors.primaryColor.rawValue)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(tagNameLabel)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(named: AppColors.secondaryColor.rawValue)
        
        NSLayoutConstraint.activate([
            tagNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tagNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configureCell(with tag: Tag) {
        tagNameLabel.text = tag.name
    }
}
