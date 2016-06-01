//
//  Player.swift
//  iPickThingsUp
//
//  Created by Internicola, Eric on 5/31/16.
//  Copyright © 2016 iColasoft. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    static let OFF_WHITE_COLOR = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)

    convenience init() {
        self.init(color: Player.OFF_WHITE_COLOR, size: CGSize(width: 30, height: 30))
        setupPhysics()
    }
}

// MARK: - API

extension Player {

    func moveTo(location: CGPoint) {
        let rotation = atan2(location.y - position.y, location.x - position.x) - CGFloat(M_PI_2)
        zRotation = rotation
        let moveAction = SKAction.moveTo(location, duration: 1)
        runAction(moveAction)
    }

}

// MARK: - Helpers

private extension Player {

    func setupPhysics() {
        let collider = SKPhysicsBody(rectangleOfSize: size)
        collider.affectedByGravity = false
        collider.allowsRotation = false
        collider.categoryBitMask = PhysicsCategory.Player.rawValue
        collider.contactTestBitMask = PhysicsCategory.Square.rawValue

        physicsBody = collider
    }
}