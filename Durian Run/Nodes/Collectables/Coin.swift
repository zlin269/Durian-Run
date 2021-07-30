//
//  Coin.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/30.
//

import SpriteKit

class Coin: Collectable {
	
	init() {
		super.init(imageNamed: "gold")
		self.scale(to: CGSize(width: 70, height: 70))
		self.physicsBody?.affectedByGravity = false
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	static func spawnCoinsRainbow(_ position: CGPoint, _ parent: SKNode) {
		let c_mid = Coin()
		c_mid.position = position
		c_mid.run(SKAction.moveBy(x: -parent.frame.width - 500, y: 0, duration: TimeInterval((parent.frame.width + 500) / GameScene.platformSpeed)), completion: {
			c_mid.removeFromParent()
		})
		parent.addChild(c_mid)
		for i in 1...2 {
			let c = Coin()
			c.position = position
			c.position.x -= sqrt(CGFloat(i)) * 200
			c.position.y -= 50 * pow(CGFloat(i), 2)
			c.run(SKAction.moveBy(x: -parent.frame.width - 500, y: 0, duration: TimeInterval((parent.frame.width + 500) / GameScene.platformSpeed)), completion: {
				c.removeFromParent()
			})
			parent.addChild(c)
		}
		for i in 1...2 {
			let c = Coin()
			c.position = position
			c.position.x += sqrt(CGFloat(i)) * 200
			c.position.y -= 50 * pow(CGFloat(i), 2)
			parent.addChild(c)
			c.run(SKAction.moveBy(x: -parent.frame.width - 500, y: 0, duration: TimeInterval((parent.frame.width + 500) / GameScene.platformSpeed)), completion: {
				c.removeFromParent()
			})
		}
		
	}
}
