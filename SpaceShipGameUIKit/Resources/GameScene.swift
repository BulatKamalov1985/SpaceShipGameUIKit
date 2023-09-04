//
//  GameScene.swift
//  SpaceShipGameUIKit
//
//  Created by Bulat Kamalov on 15.08.2023.
//
import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    
    let playerCategory: UInt32 = 0x1
    let enemyCategory: UInt32 = 0x10
    
    private var starfield = SKEmitterNode()
    private var player = SKSpriteNode()
    private var enemy = SKSpriteNode()
    private var enemyCounterLabel = SKLabelNode()
    private var nameLabel = SKLabelNode()
    var enemyCounter = 0
    private var fireTimer: Timer?
    private var enemyTimer: Timer?
    var isCollisionOccurred = false
    var isGameRunning = true
    
    var playerName: String = ""
    var nameScoreDictionary: [String: Int] = [:]
    
    
    // MARK: - Scene Lifecycle
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        setupScene()
        startTimers()
    }
    
    
    // MARK: - Setup
    
    func setupScene() {
        scene?.size = CGSize(width: 750, height: 1335)
        createStarfield()
        if let selectedShipName = UserDefaults.standard.string(forKey: "SelectedShipName") {
            createPlayer(playerType: selectedShipName)
        }
        createCountLabel()
        createNameLabel()
    }
    
    private func createStarfield() {
        starfield = SKEmitterNode(fileNamed: "Starfield") ?? SKEmitterNode()
        starfield.position = CGPoint(x: size.width / 2, y: size.height / 2)
        starfield.zPosition = -1
        addChild(starfield)
    }
    
    func createPlayer(playerType: String) {
        player = SKSpriteNode(imageNamed: playerType)
        player.position = CGPoint(x: size.width / 2, y: 120)
        player.setScale(0.6)
        player.zPosition = 19
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.isDynamic = false
        player.name = "PLAYER"
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.contactTestBitMask = enemyCategory
        player.physicsBody?.collisionBitMask = 0
        addChild(player)
    }

    private func createCountLabel() {
        enemyCounterLabel = SKLabelNode(text: "Enemies: 0")
        enemyCounterLabel.fontName = "Helvetica-Bold"
        enemyCounterLabel.fontSize = 30
        enemyCounterLabel.fontColor = .white
        enemyCounterLabel.position = CGPoint(x: size.width - 160, y: size.height - 100)
        enemyCounterLabel.zPosition = 10
        addChild(enemyCounterLabel)
        
        let borderRect = CGRect(x: enemyCounterLabel.frame.origin.x - 30,
                                y: enemyCounterLabel.frame.origin.y - 5,
                                width: enemyCounterLabel.frame.size.width + 60,
                                height: enemyCounterLabel.frame.size.height + 10)
        
        let border = SKShapeNode(rect: borderRect, cornerRadius: 10)
        border.strokeColor = SKColor.white
        border.lineWidth = 2
        border.zPosition = 9
        addChild(border)
    }
    
    private func createNameLabel() {
        nameLabel = SKLabelNode(text: playerName)
        nameLabel.fontName = "Helvetica-Bold"
        nameLabel.fontSize = 30
        nameLabel.numberOfLines = 0
        nameLabel.fontColor = .white
        nameLabel.position = CGPoint(x: size.width - 100, y: size.height - 150)
        nameLabel.zPosition = 10
        addChild(nameLabel)
    }
    
    // MARK: - Timers
    
    func startTimers() {
        if isGameRunning {
            enemyTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(makeEnemies), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimers() {
        enemyTimer?.invalidate()
    }
    
    // MARK: - Actions
    
    @objc private func makeEnemies() {
        let randomNumber = GKRandomDistribution(lowestValue: 50, highestValue: 700)
        enemy = SKSpriteNode(imageNamed: "Solar Strider")
        enemy.setScale(0.2)
        enemy.position = CGPoint(x: randomNumber.nextInt(), y: 1400)
        enemy.zPosition = 5
        enemy.name = "ENEMY"
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 2)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = playerCategory
        enemy.physicsBody?.collisionBitMask = 0
        addChild(enemy)
        // Задаю скорость врагов
        if let savedStepperValue = UserDefaults.standard.value(forKey: "StepperValue") as? Double {
            let moveAction = SKAction.moveTo(y: -100, duration: savedStepperValue)
            let delateAction = SKAction.removeFromParent()
            let combine = SKAction.sequence([moveAction, delateAction])
            enemy.run(combine)
            enemyCounter += 1
            updateEnemyCounterLabel(count: enemyCounter)
        } else {
            print("Stepper value not found in UserDefaults or not a Double")
        }
    }
    
    private func updateEnemyCounterLabel(count: Int) {
        enemyCounterLabel.text = "Enemies: \(count)"
    }
    
    func restartGame() {
        removeAllChildren()
        setupScene()
        isCollisionOccurred = false
        enemyCounter = 0
        isGameRunning = true
        startTimers()
    }
    
    
    // MARK: - Touches
    
    // Метод для обработки перемещения игрока при касаниях на экран
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            player.position.x = location.x
        }
    }
    
    // Метод для показа всплывающего окна с сообщением об окончании игры после столкновения
    @objc private func showGameOverAlert() {
        let alert = UIAlertController(title: "Игра окончена", message: "Вы столкнулись с врагом!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.saveScore()
            self?.restartGame() // Перезапук игры и таймеров здесь
            self?.enemyCounter = 0
        }
        alert.addAction(okAction)
        
        if let window = view?.window, let viewController = window.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveScore() {
        // Сохраняю текущее значение очков для текущего имени игрока
        if let playerName = nameLabel.text,
           let scoreString = enemyCounterLabel.text?.split(separator: " ").last,
           let score = Int(scoreString) {
            
            // Получаю текущий словарь из UserDefaults
            var nameScoreDictionary = UserDefaults.standard.dictionary(forKey: "NameScoreDictionary") as? [String: Int] ?? [:]
            
            // Проверяю, есть ли уже запись для данного имени в словаре
            if let existingScore = nameScoreDictionary[playerName] {
                // Если текущее значение очков больше или равно существующему, обновляю запись
                if score >= existingScore {
                    nameScoreDictionary[playerName] = score
                    // Сохраню обновленный словарь обратно в UserDefaults
                    UserDefaults.standard.set(nameScoreDictionary, forKey: "NameScoreDictionary")
                    print("Данные сохранились")
                } else {
                    print("Текущее значение очков меньше существующего")
                }
            } else {
                // Если записи для данного имени еще нет, добавляю новую запись
                nameScoreDictionary[playerName] = score
                // Сохраняю обновленный словарь обратно в UserDefaults
                UserDefaults.standard.set(nameScoreDictionary, forKey: "NameScoreDictionary")
                print("Данные сохранились")
            }
        } else {
            print("Ошибка при сохранении данных")
        }
    }

    
    // MARK: - Collision
    
    // Метод для обработки столкновений объектов и показа взрывов
    func didBegin(_ contact: SKPhysicsContact) {
        // Определяю узлы, с которыми произошло столкновение
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        
        // Проверяю наличие узлов, с которыми произошло столкновение
        guard let nodeA = bodyA, let nodeB = bodyB else {
            return
        }
        
        // Проверяю, если player столкнулся с врагом, удаляю оба узла
        if (nodeA.name == "ENEMY" && nodeB.name == "PLAYER") || (nodeB.name == "ENEMY" && nodeA.name == "PLAYER") {
            player.removeFromParent()
            nodeA.removeFromParent()
            nodeB.removeFromParent()
            isCollisionOccurred = true
            isGameRunning = false
            stopTimers()
            showGameOverAlert()
        }
        
        // Определяю позицию столкновения и показываю взрыв
        let collisionPosition = contact.contactPoint
        showExplosion(at: collisionPosition)
    }
    
    // Метод для показа взрыва на заданной позиции
    func showExplosion(at position: CGPoint) {
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = position
        explosion.zPosition = 10
        explosion.setScale(0.3)
        addChild(explosion)
        
        // Анимация взрыва
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, remove])
        explosion.run(sequence)
    }
    
    private func resetPlayer() {
        // Удаляю старого игрока, если он уже существует
        player.removeFromParent()
        
        // Пересоздаю игрока
        createPlayer(playerType: "")
        
        // Сбрасываю флаг isCollisionOccurred, чтобы игрок мог стрелять снова
        isCollisionOccurred = false
    }
    
    // MARK: - Deinit
    
    // Метод для остановки таймеров перед освобождением памяти
    deinit {
        stopTimers()
    }
}
