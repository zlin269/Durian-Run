//
//  Wall.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/5.
//
import SpriteKit

class Wall: Enemy {
	
	init() {
		super.init(imageNamed: "springMan_stand", withHealth: 100, withSpeed: GameScene.platformSpeed * 1.2)
		self.name = "wall"
		self.xScale = 1
		self.yScale = 3
		self.physicsBody?.categoryBitMask = HitMask.platform
		self.physicsBody?.contactTestBitMask = HitMask.boundary
		self.physicsBody?.collisionBitMask = HitMask.platform | HitMask.durian
		self.physicsBody?.mass = 10
		self.physicsBody?.restitution = 0
		// moveSlowly()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func selfDestruction() {
		self.removeFromParent()
	}
	
	
	
}

