//
//  WelcomeViewController.swift
//  SpaceShipGameUIKit
//
//  Created by Bulat Kamalov on 15.08.2023.
//
import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Настройка интерфейса
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Welcome to the Game!"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let startGameButton = UIButton()
        startGameButton.setTitle("Start Game", for: .normal)
        startGameButton.setTitleColor(.blue, for: .normal)
        startGameButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        startGameButton.addTarget(self, action: #selector(startGameButtonTapped), for: .touchUpInside)
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startGameButton)
        
        let shipSelectionButton = UIButton()
        shipSelectionButton.setTitle("Ship Selection", for: .normal)
        shipSelectionButton.setTitleColor(.blue, for: .normal)
        shipSelectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        shipSelectionButton.addTarget(self, action: #selector(shipSelectionButtonTapped), for: .touchUpInside)
        shipSelectionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shipSelectionButton)
        
        let openSettingScreenButton = UIButton()
        openSettingScreenButton.setTitle("Open Setting Screen", for: .normal)
        openSettingScreenButton.setTitleColor(.blue, for: .normal)
        openSettingScreenButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        openSettingScreenButton.addTarget(self, action: #selector(openSettingScreenButtonTapped), for: .touchUpInside)
        openSettingScreenButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(openSettingScreenButton)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, startGameButton, shipSelectionButton, openSettingScreenButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func startGameButtonTapped() {
        // Действие при нажатии кнопки "Start Game"
    }
    
    @objc private func shipSelectionButtonTapped() {
        // Действие при нажатии кнопки "Ship Selection"
    }
    
    @objc private func openSettingScreenButtonTapped() {
        // Действие при нажатии кнопки "Open Setting Screen"
    }
}
