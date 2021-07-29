//
//  Fly.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/29.
//

import SpriteKit

class Fly: Enemy {
	
	init() {
		super.init(imageNamed: "spikeMan_walk1", withHealth: 1, withSpeed: GameScene.platformSpeed * 1.5)
		self.name = "fly"
		self.xScale = -1
		self.yScale = 1.5
		self.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "spikeMan_walk1"), SKTexture(imageNamed: "spikeMan_walk2")], timePerFrame: 0.5)))
		self.physicsBody?.affectedByGravity = false
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
