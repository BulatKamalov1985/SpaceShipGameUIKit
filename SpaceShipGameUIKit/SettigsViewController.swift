//
//  SettigsViewController.swift
//  SpaceShipGameUIKit
//
//  Created by Bulat Kamalov on 16.08.2023.
//

import UIKit

class SettingsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    // MARK: - UI Elements
    
    let aircraftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let namePlayerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameShipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        label.text = "Выбери космический корабль"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введи свое имя"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let saveSettingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить настройки", for: .normal)
        button.backgroundColor = .cyan
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionSaveSettingsButtonTapped), for: .touchUpInside)
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
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        saveNamePlayer()
        loadStepperValue()
    }

    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(namePlayerLabel)
        view.addSubview(nameTextField)
        view.addSubview(saveSettingsButton)
        view.addSubview(speedStepper)
        view.addSubview(valueSpeedLabel)
        view.addSubview(aircraftCollectionView)
        view.addSubview(nameShipLabel)
        
        aircraftCollectionView.dataSource = self
        aircraftCollectionView.delegate = self
        aircraftCollectionView.register(ShipCollectionViewCell.self, forCellWithReuseIdentifier: ShipCollectionViewCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            aircraftCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            aircraftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            aircraftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            aircraftCollectionView.heightAnchor.constraint(equalToConstant: 150),
            
            nameShipLabel.topAnchor.constraint(equalTo: aircraftCollectionView.bottomAnchor, constant: 20),
            nameShipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameShipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameShipLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            namePlayerLabel.topAnchor.constraint(equalTo: nameShipLabel.bottomAnchor, constant: 60),
            namePlayerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            namePlayerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            nameTextField.topAnchor.constraint(equalTo: namePlayerLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            valueSpeedLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 60),
            valueSpeedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            speedStepper.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 60),
            speedStepper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            saveSettingsButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            saveSettingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveSettingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            saveSettingsButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ShipsDataStorage.shipNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShipCollectionViewCell.reuseIdentifier, for: indexPath) as! ShipCollectionViewCell
        let shipName = ShipsDataStorage.shipNames[indexPath.item]
        cell.configure(with: shipName)
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedName = ShipsDataStorage.shipNames[indexPath.item]
        nameShipLabel.text = selectedName
        UserDefaults.standard.set(selectedName, forKey: "SelectedShipName")
        aircraftCollectionView.reloadData() // Обновляем коллекцию для обновления стиля выбранной ячейки
    }
    
    // MARK: - UI Actions
    
    @objc private func actionSaveSettingsButtonTapped() {
        if let name = nameTextField.text, !name.isEmpty {
            UserDefaults.standard.set(name, forKey: "PlayerName")
            namePlayerLabel.text = "Игрок: \(name)"
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.saveSettingsButton.backgroundColor = .green
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.saveSettingsButton.backgroundColor = .cyan
            }
        }
        nameTextField.text = ""
    }
    
    @objc private func stepperValueChanged() {
        let value = speedStepper.value
        valueSpeedLabel.text = "Уровень скорости: \(String(Int(value)))"
        saveStepperValue(number: value)
    }

    // MARK: - UserDefaults
    
    private func saveNamePlayer() {
        if let playerName = UserDefaults.standard.string(forKey: "PlayerName") {
            namePlayerLabel.text = "Игрок: \(playerName)"
        }
    }
    
    private func saveStepperValue(number: Double?) {
        if let stepperValue = number {
            UserDefaults.standard.set(stepperValue, forKey: "StepperValue")
        }
    }
    
    private func loadStepperValue() {
        if let savedStepperValue = UserDefaults.standard.value(forKey: "StepperValue") as? Double {
            speedStepper.value = savedStepperValue
            valueSpeedLabel.text = "Уровень скорости: \(Int(savedStepperValue))"
        } else {
            // Если значение не найдено в UserDefaults, установите значение по умолчанию
            speedStepper.value = 10
            valueSpeedLabel.text = "Уровень скорости: 10"
        }
    }
}
