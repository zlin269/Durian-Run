//
//  DurianWithGun.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/9.
//

import SpriteKit

class DurianWithGun: Durian {
    
    private var isOnCD = false
    
    override func attack() {
        if !isOnCD {
            print("Power Shot")
            let bullet = SKShapeNode(circleOfRadius: 15)
            bullet.name = "bullet"
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: 15)
            bullet.physicsBody?.affectedByGravity = false
            bullet.physicsBody?.categoryBitMask = HitMask.bullet
            bullet.physicsBody?.collisionBitMask = 0
            bullet.physicsBody?.contactTestBitMask = HitMask.enemy
            bullet.fillColor = .gray
            bullet.strokeColor = .red
            bullet.lineWidth = 5
            self.addChild(bullet)
            bullet.run(SKAction.moveTo(x: (self.parent?.frame.maxX)! + 100, duration: 1), completion: {
                bullet.removeFromParent()
            })
            isOnCD = true
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(attackCD)) {
                self.isOnCD = false
            }
        }
    }
    
    override var attackCD: CGFloat {
        return state == .boost ? 0.5 : 10
    }
}
