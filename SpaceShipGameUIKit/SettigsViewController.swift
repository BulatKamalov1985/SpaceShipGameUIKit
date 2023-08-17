//
//  SettigsViewController.swift
//  SpaceShipGameUIKit
//
//  Created by Bulat Kamalov on 16.08.2023.
//

import UIKit

class SettingsViewController:  UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var selectedShipName: String?
    
    let selectedShipButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderWidth = 2 // Добавляем толщину рамки
        button.layer.borderColor = UIColor.blue.cgColor // Цвет рамки
        button.layer.cornerRadius = 12
        button.setTitleColor(.black, for: .normal) // Цвет текста кнопки
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(selectedShipButtonTapped), for: .touchUpInside) // Добавляем обработчик нажатия
        return button
    }()

    
    let aircraftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .blue
        return collectionView
    }()
    
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
    
    let shipNames = ["ship", "ship1", "ship2", "ship3", "ship4"] // Массив имен моделей кораблей
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupCollectionView() // Добавляем инициализацию коллекции
        saveNamePlayer()
        loadStepperValue()
        selectedShipButton.setTitle("Выбранный корабль", for: .normal) // Заголовок кнопки по умолчанию
        view.addSubview(selectedShipButton)
    }
    
    @objc private func selectedShipButtonTapped() {
        if let selectedName = selectedShipName {
            let alert = UIAlertController(title: "Выбранный корабль", message: "Вы выбрали корабль: \(selectedName)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Выбранный корабль", message: "Корабль не выбран", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func setupUI() {
        view.addSubview(selectedShipButton)
        view.addSubview(nameTitleLabel)
        view.addSubview(nameTextField)
        view.addSubview(actionButton)
        view.addSubview(speedStepper)
        view.addSubview(valueSpeedLabel)
        view.addSubview(aircraftCollectionView)
        
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
            
            valueSpeedLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 40),
            valueSpeedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            speedStepper.topAnchor.constraint(equalTo: valueSpeedLabel.bottomAnchor, constant: 40),
            speedStepper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speedStepper.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            selectedShipButton.topAnchor.constraint(equalTo: aircraftCollectionView.bottomAnchor, constant: 20),
            selectedShipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectedShipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            selectedShipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
        
    }
    
    func setupCollectionView() {
        view.addSubview(aircraftCollectionView)
        
        aircraftCollectionView.dataSource = self
        aircraftCollectionView.delegate = self
        
        aircraftCollectionView.register(ShipCollectionViewCell.self, forCellWithReuseIdentifier: ShipCollectionViewCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            aircraftCollectionView.topAnchor.constraint(equalTo: speedStepper.bottomAnchor, constant: 20),
            aircraftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            aircraftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            aircraftCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shipNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShipCollectionViewCell.reuseIdentifier, for: indexPath) as! ShipCollectionViewCell
        let shipName = shipNames[indexPath.item]
        cell.configure(with: shipName)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedName = shipNames[indexPath.item]
        selectedShipName = selectedName
        selectedShipButton.setTitle(selectedShipName, for: .normal) // Устанавливаем название картинки в заголовок кнопки
        aircraftCollectionView.reloadData() // Обновляем коллекцию для обновления стиля выбранной ячейки
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
