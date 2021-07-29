//
//  Enemy.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/20.
//

import SpriteKit

class Enemy: SKSpriteNode {
	
	private var health: Int {
		didSet {
			if health <= 0 {
				selfDestruction()
			}
		}
	}
	
	private var movementSpeed: CGFloat
	
	init(imageNamed imageName: String, withHealth health: Int, withSpeed speed: CGFloat) {
		self.health = health
		self.movementSpeed = speed
		super.init(texture: SKTexture(imageNamed: imageName), color: UIColor.red, size: CGSize(width: 130, height: 130))
		self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 120, height: 120))
		self.physicsBody?.isDynamic = true
		self.physicsBody?.affectedByGravity = true
		self.physicsBody?.allowsRotation = false
		self.physicsBody?.friction = 0
		self.physicsBody?.categoryBitMask = HitMask.enemy
		self.physicsBody?.contactTestBitMask = HitMask.durian
		self.physicsBody?.collisionBitMask = HitMask.platform | HitMask.enemy
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func receiveDamage(_ dmg: Int) {
		self.health -= dmg
	}
	
	func selfDestruction() {
		self.run(SKAction.sequence([SKAction.moveBy(x: 0, y: 100, duration: 1), SKAction.moveBy(x: 0, y: -2000, duration: 1)]))
		self.run(SKAction.rotate(byAngle: .pi*4, duration: 1), completion: {
			self.removeFromParent()
		})
	}
	
	func move(){
		self.position.x = self.position.x - movementSpeed
	}
}
