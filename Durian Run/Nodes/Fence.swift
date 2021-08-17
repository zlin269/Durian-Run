//
//  Fens.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/17.
//

import SpriteKit


class Fence: SKSpriteNode {
    
    init(type: UInt32) {
        var texture = SKTexture()
        switch type {
        case 1:
            texture = SKTexture(imageNamed: "fence_s")
        case 2:
            texture = SKTexture(imageNamed: "fence_m")
        case 3:
            texture = SKTexture(imageNamed: "fence_l")
        default:
            texture = SKTexture(imageNamed: "cone")
        }
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: texture.size().width * 3, height: texture.size().height * 3))
        switch type {
        case 1, 2:
            self.physicsBody = SKPhysicsBody(rectangleOf: frame.size, center: CGPoint(x: frame.midX, y: frame.midY))
        case 3:
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: frame.height / 2), center: CGPoint(x: frame.midX, y: frame.midY + frame.height / 4))
        default:
            self.physicsBody = SKPhysicsBody(texture: texture, size: frame.size)
        }
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = HitMask.platform
        self.physicsBody?.contactTestBitMask = HitMask.durian
        self.physicsBody?.restitution = 0
        self.physicsBody?.friction = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func move(speed: CGFloat, _ dt: TimeInterval){
        self.position.x = self.position.x - speed * CGFloat(dt)
    }
}
