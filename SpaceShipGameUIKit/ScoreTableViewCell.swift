//
//  ScoreTableViewCell.swift
//  SpaceShipGameUIKit
//
//  Created by Bulat Kamalov on 16.08.2023.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String { "\(Self.self)" }
    
    let playerNameLabel = UILabel()
    let scoreLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(playerName: String, score: Int) {
            playerNameLabel.text = playerName
            scoreLabel.text = "Score: \(score)"
        }

    private func setupUI() {
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(playerNameLabel)
        contentView.addSubview(scoreLabel)

        NSLayoutConstraint.activate([
            playerNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            playerNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
