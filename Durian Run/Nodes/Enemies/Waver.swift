//
//  Waver.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/5.
//


import SpriteKit

class Waver: Enemy {
	
	init() {
		super.init(imageNamed: "flyMan_fly", withHealth: 1, withSpeed: GameScene.platformSpeed * 1.5)
		self.name = "fly"
		self.xScale = 1.5
		self.yScale = 1.5
		self.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "flyMan_fly"), SKTexture(imageNamed: "flyMan_still_fly")], timePerFrame: 0.5)))
		self.physicsBody?.affectedByGravity = false
		self.physicsBody?.collisionBitMask = 0
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func move(_ dt: TimeInterval){
		self.position.x = self.position.x - movementSpeed * CGFloat(dt)
		self.position.y = sin( abs(position.x / 2532) * 3 * .pi) * 300 + 600
	}
}
