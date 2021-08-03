//
//  Durian.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/16.
//

import SpriteKit

// A platform consists of many blocks of grass
class Platform: SKNode {
	
	var width :CGFloat = 0
	
	private var isInitial : Bool = false
	
	override init() {
		super.init()
		self.physicsBody = SKPhysicsBody()
        
	}
	
	init(initial: Bool) {
		isInitial = initial
		super.init()
		self.physicsBody = SKPhysicsBody()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func create (number: Int) {
		
		let grass_m = SKSpriteNode(imageNamed: "grassMid")
		grass_m.size = CGSize(width: grass_m.size.width * CGFloat(number) * 2, height: grass_m.size.height * 2)
		grass_m.anchorPoint = CGPoint(x: 0, y: 0)
		width = grass_m.size.width
		self.addChild(grass_m)
		
		
		self.physicsBody = SKPhysicsBody(rectangleOf: grass_m.size, center: CGPoint(x: width / 2, y: grass_m.size.height / 2))
		self.physicsBody?.isDynamic = false
		self.physicsBody?.categoryBitMask = HitMask.platform
		self.physicsBody?.contactTestBitMask = HitMask.durian 
		self.physicsBody?.restitution = 0
		self.physicsBody?.friction = 0
		
		if number > 10 && !isInitial {
			// Coin.spawnCoinsLine(number / 2, CGPoint(x: 200, y: 200), self)
		}
		
	}
	
	func move(speed: CGFloat, _ dt: TimeInterval){
        self.position.x = self.position.x - speed * CGFloat(dt)
    }
}
