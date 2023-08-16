//
//  SettigsViewController.swift
//  SpaceShipGameUIKit
//
//  Created by Bulat Kamalov on 16.08.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var nameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter something"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        if let playerName = UserDefaults.standard.string(forKey: "PlayerName") {
               nameTitleLabel.text = playerName
           }
    }

    private func setupUI() {
        view.addSubview(nameTitleLabel)
        view.addSubview(nameTextField)
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            nameTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            nameTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            actionButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            actionButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    @objc private func actionButtonTapped() {
        if let name = nameTextField.text, !name.isEmpty {
            UserDefaults.standard.set(name, forKey: "PlayerName")
            nameTitleLabel.text = name
        }
    }
}
