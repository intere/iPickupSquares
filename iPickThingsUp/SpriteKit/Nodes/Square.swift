//
//  Square.swift
//  iPickThingsUp
//
//  Created by Internicola, Eric on 5/31/16.
//  Copyright © 2016 iColasoft. All rights reserved.
//

import SpriteKit

class Square: SKSpriteNode {
    static let OFF_BLACK_COLOR = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)

    convenience init() {
        self.init(color: Square.OFF_BLACK_COLOR, size: CGSize(width: 10, height: 10))
        setupPhysics()
    }

}


// MARK: - Helpers

private extension Square {

    func setupPhysics() {
        let collider = SKPhysicsBody(rectangleOfSize: size)
        collider.affectedByGravity = false
        collider.allowsRotation = false
        collider.categoryBitMask = PhysicsCategory.Square.rawValue
        collider.contactTestBitMask = PhysicsCategory.Player.rawValue

        physicsBody = collider
    }

}