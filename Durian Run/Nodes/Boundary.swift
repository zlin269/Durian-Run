//
//  boundary.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/24.
//

import SpriteKit

class Boundary: SKNode {
	
	override init() {
		super.init()
		let bottomBoundary = SKSpriteNode(color: UIColor.red, size: CGSize(width: 3000, height: 1))
		bottomBoundary.anchorPoint = CGPoint(x: 0, y: 0)
		let leftBoundary = SKSpriteNode(color: UIColor.red, size: CGSize(width: 1, height: 2000))
		leftBoundary.anchorPoint = CGPoint(x: 0, y: 0)
		self.addChild(bottomBoundary)
		self.addChild(leftBoundary)
		bottomBoundary.position = CGPoint(x:0, y:0)
		leftBoundary.position = CGPoint(x:0, y:0)
		bottomBoundary.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0), to: CGPoint(x: 3000, y: 0))
		leftBoundary.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: 2000))
		self.physicsBody = SKPhysicsBody(bodies: [leftBoundary.physicsBody!, bottomBoundary.physicsBody!])
		self.physicsBody?.isDynamic = false
		self.physicsBody?.categoryBitMask = HitMask.boundary
		self.physicsBody?.contactTestBitMask = 0xFFFFFFFF
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
