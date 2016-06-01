//
//  GameScene.swift
//  iPickThingsUp
//
//  Created by Internicola, Eric on 3/8/16.
//  Copyright (c) 2016 iColasoft. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var lblTitle: SKLabelNode!
    var lblScore: SKLabelNode!
    var player: Player!
    var score = 0
    var gameOver = false

    class func createScene() -> GameScene? {
        let scene = GameScene(fileNamed:"GameScene")
        scene?.scaleMode = .ResizeFill

        return scene
    }

    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.orangeColor()

        lblTitle = spawnTitleLabel()
        lblScore = spawnScoreLabel()
        player = spawnPlayer()

        physicsWorld.contactDelegate = self
    }

    override func update(currentTime: CFTimeInterval) {
        lblScore.text = "\(score)"
    }
}

// MARK: UI Actions

extension GameScene {

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        guard !gameOver else {
            return
        }

        for touch in touches {
            let location = touch.locationInNode(self)
            player.moveTo(location)
        }
    }

}

// MARK: - SKPhysicsContactDelegate Methods

extension GameScene : SKPhysicsContactDelegate {

    func didBeginContact(contact: SKPhysicsContact) {
        guard let _ = contact.bodyA.node as? Player ?? contact.bodyB.node as? Player else {
            print("No Player in the collision")
            return
        }
        guard let square = contact.bodyA.node as? Square ?? contact.bodyB.node as? Square else {
            print("No square involved in the collision")
            return
        }
        score += 1
        square.removeFromParent()
    }

}

// MARK: - Spawn Methods

extension GameScene {

    func spawnTitleLabel() -> SKLabelNode {
        let title = SKLabelNode(fontNamed: "Futura")
        title.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        title.fontColor = Player.OFF_WHITE_COLOR
        title.fontSize = 50
        title.text = "I Pick Things Up"
        addChild(title)

        title.runAction(SKAction.waitForDuration(1.5)) {
            self.countDown()
        }

        return title
    }

    func spawnScoreLabel() -> SKLabelNode {
        let score = SKLabelNode(fontNamed: "Futura")
        score.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame)+50)
        score.fontSize = 30
        score.fontColor = Player.OFF_WHITE_COLOR
        score.text = "Score: 0"
        addChild(score)

        return score
    }

    func spawnSquare() {
        let randomX: CGFloat = random() * CGRectGetMaxX(frame)
        let randomY: CGFloat = random() * CGRectGetMaxY(frame)

        let square = Square()
        square.position = CGPoint(x: randomX, y: randomY)
        addChild(square)
    }

    func spawnPlayer() -> Player {
        let player = Player()
        player.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame)-40)

        addChild(player)
        return player
    }
}

// MARK: - Timer Methods

extension GameScene {

    func countDown() {
        var actions = [SKAction]()
        let count = 15

        for i in 0..<count {
            actions.append(SKAction.runBlock({
                self.lblTitle.text = "\(count-i)"
            }))

            actions.append(SKAction.waitForDuration(1))
            guard i == count.advancedBy(-1) else {
                continue
            }
            actions.append(SKAction.runBlock {
                self.gameOver = true
                self.lblTitle.text = "Game Over"
            })
            actions.append(SKAction.waitForDuration(3))
            actions.append(SKAction.runBlock {
                self.newGame()
            })
        }

        runAction(SKAction.sequence(actions))
        for _ in 0..<3 {
            self.spawnSquareTimer()
        }

    }

    func spawnSquareTimer() {
        guard !gameOver else {
            return
        }
        spawnSquare()
        let waitTime = NSTimeInterval((random() % 2000) / 1000)
        runAction(SKAction.waitForDuration(waitTime)) {
            self.spawnSquareTimer()
        }
    }

    func newGame() {
        guard let gameScene = GameScene.createScene() else {
            print("Couldn't create a new game scene")
            return
        }
        gameScene.scaleMode = .ResizeFill

        self.view?.presentScene(gameScene, transition: SKTransition.doorsOpenHorizontalWithDuration(1.5))
    }

}

enum PhysicsCategory: UInt32 {
    case Player = 0b1
    case Square = 0b10
}
