//
//  TagCell.swift
//  stayConect
//
//  Created by Nkhorbaladze on 01.12.24.
//

import UIKit

class TagCell: UICollectionViewCell {
    static let identifier = "TagCell"

    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: StayConnectFonts.interRegular.rawValue, size: 11)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with text: String, isSelected: Bool = false) {
        label.text = text
        contentView.backgroundColor = isSelected ? UIColor(hex: "4F46E5") : UIColor(hex: "EEF2FF")
        label.textColor = isSelected ? .white : UIColor(hex: "4F46E5")
    }
}
