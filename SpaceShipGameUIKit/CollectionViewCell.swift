//
//  CollectionViewCell.swift
//  SpaceShipGameUIKit
//
//  Created by Bulat Kamalov on 17.08.2023.
//

import UIKit

class ShipCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ShipCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override var isSelected: Bool {
            didSet {
                contentView.layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.black.cgColor
            }
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        
        // Добавляем черную рамку
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    func configure(with imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
}
