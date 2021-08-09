//
//  DurianWithAttack.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/9.
//

import SpriteKit

class DurianWithAttack: Durian {
    
    override func attack() {
        print("Quill Spray")
        let damageRadius : CGFloat = 800
        let gamescene = self.parent as? GameScene
        /*
        for enemy in gamescene!.enemies {
            let xDistance = enemy.position.x - self.position.x
            let yDistance = enemy.position.y - self.position.y
            if Double(xDistance * xDistance + yDistance * yDistance) < Double(damageRadius * damageRadius) {
                enemy.receiveDamage(1)
            }
        }
        */
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
        circle.run(SKAction.scale(to: 2.5, duration: 0.2), completion: {
            circle.removeFromParent()
        })
    }
    
}
