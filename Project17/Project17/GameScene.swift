//
//  GameScene.swift
//  Project17
//
//  Created by Adarsh Singh on 18/09/23.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var possibleEnemies = ["ball", "hammer", "tv"]
    var isGameOver = false
    var gameTimer: Timer?
    var gameOver: SKLabelNode!

    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        backgroundColor = .black

            starfield = SKEmitterNode(fileNamed: "starfield")!
            starfield.position = CGPoint(x: 1024, y: 384)
            starfield.advanceSimulationTime(10)
            addChild(starfield)
            starfield.zPosition = -1

            player = SKSpriteNode(imageNamed: "player")
            player.position = CGPoint(x: 100, y: 384)
            player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
            player.physicsBody?.contactTestBitMask = 1
            addChild(player)

            scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
            scoreLabel.position = CGPoint(x: 16, y: 40)
            scoreLabel.horizontalAlignmentMode = .left
            addChild(scoreLabel)

            score = 0

            physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        for node in children {
                if node.position.x < -300 {
                    node.removeFromParent()
                }
            }

            if !isGameOver {
                score += 1
            }
    }
    @objc func createEnemy() {
        guard let enemy = possibleEnemies.randomElement() else { return }

        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)

        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }

        player.position = location
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)

        player.removeFromParent()
        possibleEnemies.removeAll()
        gameOver = SKLabelNode(fontNamed: "Chalkduster")
        gameOver.text = "GAME OVER"
        gameOver.position = CGPoint(x: 500, y: 400)
        gameOver.horizontalAlignmentMode = .center
        addChild(gameOver)

        isGameOver = true
    }
}
