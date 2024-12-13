//
//  EmptyStateView.swift
//  stayConect
//
//  Created by Nkhorbaladze on 30.11.24.
//

import UIKit

final class EmptyStateView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let primaryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: StayConnectFonts.interRegular.rawValue, size: 16)
        label.textColor = UIColor(hex: "5E6366")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: StayConnectFonts.interRegular.rawValue, size: 16)
        label.textColor = UIColor(hex: "000000")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(primaryLabel)
        addSubview(secondaryLabel)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            
            secondaryLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -20),
            secondaryLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            
            primaryLabel.bottomAnchor.constraint(equalTo: secondaryLabel.topAnchor, constant: -13),
            primaryLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
    }
    
    func configure(imageName: String, primaryText: String, secondaryText: String) {
        imageView.image = UIImage(named: imageName)
        primaryLabel.text = primaryText
        secondaryLabel.text = secondaryText
    }
}
