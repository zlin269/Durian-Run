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
        case 4:
            texture = SKTexture(imageNamed: "fence_long")
        case 5:
            texture = SKTexture(imageNamed: "fence_tall")
        case 6:
            texture = SKTexture(imageNamed: "dining car")
        default:
            texture = SKTexture(imageNamed: "cone")
        }
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: texture.size().width * 2, height: texture.size().height * 2))
        switch type {
        case 1, 2, 6:
            self.physicsBody = SKPhysicsBody(rectangleOf: frame.size, center: CGPoint(x: frame.midX, y: frame.midY))
        case 3, 4:
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: frame.height / 2.8), center: CGPoint(x: frame.midX, y: frame.midY + frame.height / 4))
        case 5:
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: frame.width, height: frame.height / 4), center: CGPoint(x: frame.midX, y: frame.midY + frame.height / 3))
        default:
            self.physicsBody = SKPhysicsBody(texture: texture, size: frame.size)
            self.name = "cone"
        }
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = HitMask.platform
        self.physicsBody?.contactTestBitMask = HitMask.durian
        self.physicsBody?.restitution = 0
        self.physicsBody?.friction = 0
        
        if type == 0 {
            xScale = 0.5
            yScale = 0.5
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func move(speed: CGFloat, _ dt: TimeInterval){
        self.position.x = self.position.x - speed * CGFloat(dt)
    }
}
