//
//  DurianWithDash.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/9.
//

import SpriteKit

class DurianWithDash: Durian {
    
    private let attackCD = 2
    private var isOnCD = false
    
    override func attack() {
        if !isOnCD {
            print("Time Walk")
            self.run(SKAction.move(by: CGVector(dx: 400, dy: 0), duration: 0.1))
            let shield = SKShapeNode(circleOfRadius: 150)
            shield.name = "bullet"
            shield.physicsBody = SKPhysicsBody(circleOfRadius: 150)
            shield.physicsBody?.affectedByGravity = false
            shield.physicsBody?.categoryBitMask = HitMask.bullet
            shield.physicsBody?.collisionBitMask = 0
            shield.physicsBody?.contactTestBitMask = HitMask.enemy
            shield.fillColor = .clear
            shield.strokeColor = .red
            self.addChild(shield)
            shield.run(SKAction.move(by: CGVector(dx: 400, dy: 0), duration: 0.1), completion: {
                shield.removeFromParent()
            })
            isOnCD = true
            invincible = true
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(attackCD)) {
                self.isOnCD = false
                self.invincible = false
            }
        }
    }
    
}
