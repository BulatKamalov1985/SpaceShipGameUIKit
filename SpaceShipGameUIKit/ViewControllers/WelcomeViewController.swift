//
//  WelcomeViewController.swift
//  SpaceShipGameUIKit
//
//  Created by Bulat Kamalov on 15.08.2023.
//
import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let backgroundImage = UIImage(named: "Background")
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the Game!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let startGameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Game", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let shipSelectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Scores", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let openSettingScreenButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open Setting Screen", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        setupButtons()
        setupStackView()
        
        if let backgroundImage = backgroundImage {
            view.backgroundColor = UIColor(patternImage: backgroundImage)
        } else {
            view.backgroundColor = .white
        }
    }
    
    private func setupButtons() {
        startGameButton.addTarget(self, action: #selector(startGameButtonTapped), for: .touchUpInside)
        shipSelectionButton.addTarget(self, action: #selector(scoresButtonTapped), for: .touchUpInside)
        openSettingScreenButton.addTarget(self, action: #selector(openSettingScreenButtonTapped), for: .touchUpInside)
    }
    
    private func setupStackView() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(startGameButton)
        stackView.addArrangedSubview(shipSelectionButton)
        stackView.addArrangedSubview(openSettingScreenButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Button Actions
    
    @objc private func startGameButtonTapped() {
        let gameViewController = GameViewController()
        if let playerName = UserDefaults.standard.string(forKey: "PlayerName") {
            gameViewController.playerName = playerName
        }
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    func nontrr() {
        
    }
    @objc private func scoresButtonTapped() {
        let scoresTableViewController = ScoresTableViewController()
        navigationController?.pushViewController(scoresTableViewController, animated: true)
    }
    
    @objc private func openSettingScreenButtonTapped() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}
