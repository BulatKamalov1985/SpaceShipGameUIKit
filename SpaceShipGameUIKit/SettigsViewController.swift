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
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите свое имя"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить имя", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let speedStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 15
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    @objc let valueSpeedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        saveNamePlayer()
        loadStepperValue()
    }
    
    private func setupUI() {
        view.addSubview(nameTitleLabel)
        view.addSubview(nameTextField)
        view.addSubview(actionButton)
        view.addSubview(speedStepper)
        view.addSubview(valueSpeedLabel)
        
        NSLayoutConstraint.activate([
            nameTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            nameTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            nameTextField.topAnchor.constraint(equalTo: nameTitleLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            actionButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            actionButton.widthAnchor.constraint(equalToConstant: 160),
            
            speedStepper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speedStepper.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            valueSpeedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            valueSpeedLabel.topAnchor.constraint(equalTo: speedStepper.bottomAnchor, constant: 20)
        ])
    
    }
    
    @objc func stepperValueChanged() {
        let value = speedStepper.value
        valueSpeedLabel.text = "Value: \(String(Int(value)))"
        saveStepperValue(number: value)
    }
    
    @objc private func actionButtonTapped() {
        if let name = nameTextField.text, !name.isEmpty {
            UserDefaults.standard.set(name, forKey: "PlayerName")
            nameTitleLabel.text = "Игрок: \(name)"
        }
        nameTextField.text = ""
    }
    
    func saveStepperValue (number: Double?) {
        if let stepperValue = number {
            UserDefaults.standard.set(stepperValue, forKey: "StepperValue")
        }
    }
    
    func saveNamePlayer() {
        if let playerName = UserDefaults.standard.string(forKey: "PlayerName") {
            nameTitleLabel.text = "Игрок: \(playerName)"
        }
    }
    
    func loadStepperValue() {
        if let savedStepperValue = UserDefaults.standard.value(forKey: "StepperValue") as? Double {
            speedStepper.value = savedStepperValue
            valueSpeedLabel.text = "Value: \(Int(savedStepperValue))"
        } else {
            // Если значение не найдено в UserDefaults, установите значение по умолчанию
            speedStepper.value = 10
            valueSpeedLabel.text = "Value: 0"
        }
    }
}
