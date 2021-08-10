//
//  DurianWithAttack.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/9.
//

import SpriteKit

class DurianWithAttack: Durian {
    
    private let attackCD = 1
    private var isOnCD = false
    
    override func attack() {
        if !isOnCD {
            print("Quill Spray")
            let damageRadius : CGFloat = 800
            let scaleFactor = damageRadius / 200
            
            let circle = SKShapeNode(circleOfRadius: 200)
            circle.name = "bullet"
            circle.physicsBody = SKPhysicsBody(circleOfRadius: 200)
            circle.physicsBody?.affectedByGravity = false
            circle.physicsBody?.categoryBitMask = HitMask.bullet
            circle.physicsBody?.collisionBitMask = 0
            circle.physicsBody?.contactTestBitMask = HitMask.enemy
            circle.fillColor = .clear
            circle.strokeColor = .red
            self.addChild(circle)
            circle.run(SKAction.scale(to: scaleFactor, duration: 0.2), completion: {
                circle.removeFromParent()
            })
            isOnCD = true
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(attackCD)) {
                self.isOnCD = false
            }
        }
    }
    
}
