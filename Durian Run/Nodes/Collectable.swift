//
//  Collectable.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/20.
//

import SpriteKit

class Collectable: SKSpriteNode {
	
	var inGame: Bool = false
	
	init(imageNamed image: String) {
		super.init(texture: SKTexture(imageNamed: image), color: UIColor.white, size: CGSize(width: 200, height: 200))
		self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 200))
		self.physicsBody?.isDynamic = true
		self.physicsBody?.affectedByGravity = true
		self.physicsBody?.allowsRotation = false
		self.physicsBody?.friction = 0
		self.physicsBody?.categoryBitMask = HitMask.collectable
		self.physicsBody?.collisionBitMask = HitMask.platform | HitMask.durian
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func getCollected() {
		self.physicsBody = nil
		self.run(SKAction.move(to: CGPoint(x: 1800, y: 1000), duration: 0.5))
		self.run(SKAction.scale(to: CGSize(width: 0, height: 0), duration: 0.5), completion: {
			self.removeFromParent()
		})
		inGame = false
	}
	
	func move(speed: Int){
		self.position.x = self.position.x - CGFloat(speed)
	}
}
