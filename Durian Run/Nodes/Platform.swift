//
//  Durian.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/16.
//

import SpriteKit

// A platform consists of many blocks of grass
class Platform: SKNode {
	
	var width: CGFloat = 0 // used to decide where the next block should go
	
	override init() {
		super.init()
		self.physicsBody = SKPhysicsBody()
        
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func create (number: Int) {
		
		let grass_l = SKSpriteNode(imageNamed: "grassLeft")
		grass_l.size = CGSize(width: grass_l.size.width * 2, height: grass_l.size.height * 2)
		grass_l.anchorPoint = CGPoint(x: 0, y: 0)
		grass_l.position.x = 0
		width = grass_l.frame.width
		self.addChild(grass_l)
		
		for _ in 0..<number {
			let grass_m = SKSpriteNode(imageNamed: "grassMid")
			grass_m.size = CGSize(width: grass_m.size.width * 2, height: grass_m.size.height * 2)
			grass_m.anchorPoint = CGPoint(x: 0, y: 0)
			grass_m.position.x = width
			width += grass_m.frame.width
			self.addChild(grass_m)
		}
		
		let grass_r = SKSpriteNode(imageNamed: "grassRight")
		grass_r.size = CGSize(width: grass_r.size.width * 2, height: grass_r.size.height * 2)
		grass_r.anchorPoint = CGPoint(x: 0, y: 0)
		grass_r.position.x = width
		width += grass_r.frame.width
		self.addChild(grass_r)
		
		
		self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: grass_l.size.height), center: CGPoint(x: width/2, y: grass_l.size.height/2))
		self.physicsBody?.isDynamic = false
		self.physicsBody?.categoryBitMask = HitMask.platform
		self.physicsBody?.contactTestBitMask = HitMask.durian 
		self.physicsBody?.restitution = 0
		self.physicsBody?.friction = 0
		
	}
	
	func move(speed: CGFloat, _ dt: TimeInterval){
        self.position.x = self.position.x - speed * CGFloat(dt)
    }
}
