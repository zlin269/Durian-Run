//
//  Chaser.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/22.
//

import SpriteKit

class Chaser: Enemy {
	
	init() {
		super.init(imageNamed: "springMan_stand", withHealth: 999, withSpeed: 0)
		self.name = "DaTuoLuo"
		self.physicsBody?.affectedByGravity = false
		self.physicsBody?.collisionBitMask = 0
		self.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: 100, duration: 2),SKAction.moveBy(x: 0, y: -100, duration: 2)])))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
