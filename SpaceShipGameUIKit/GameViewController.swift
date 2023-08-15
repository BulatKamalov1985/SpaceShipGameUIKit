//
//  GameViewController.swift
//  SpaceShipGameUIKit
//
//  Created by Bulat Kamalov on 15.08.2023.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    private var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameScene()
    }

    func setupGameScene() {
        let skView = SKView(frame: view.bounds)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        view.addSubview(skView)
        
        gameScene = createGameScene(size: skView.bounds.size)
        skView.presentScene(gameScene)
    }

    func createGameScene(size: CGSize) -> GameScene {
        let gameScene = GameScene(size: size)
        return gameScene
    }
    
    // Дополнительные методы и настройки интерфейса, если нужно
}
