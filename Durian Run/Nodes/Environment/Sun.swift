//
//  Sun.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/20.
//

import SpriteKit

class Sun: SKNode {
	
	var isOpen: Bool = false
	private var cloud1: SKSpriteNode
	private var cloud2: SKSpriteNode
	private var cloud3: SKSpriteNode
	
	override init() {
		cloud1 = SKSpriteNode(imageNamed: "cloud1")
		cloud2 = SKSpriteNode(imageNamed: "cloud2")
		cloud3 = SKSpriteNode(imageNamed: "cloud3")
		super.init()
		let sun = SKSpriteNode(imageNamed: "sun")
		sun.size = CGSize(width: 300, height: 300)
		sun.position = CGPoint(x: 0, y: 0)
		sun.zPosition = 0
		cloud1.position = CGPoint(x: -100, y: -30)
		cloud1.zPosition = 1
		cloud2.position = CGPoint(x: 80, y: -30)
		cloud2.zPosition = 2
		cloud3.position = CGPoint(x: 60, y: 20)
		cloud3.zPosition = -1
		addChild(cloud3)
		addChild(sun)
		addChild(cloud1)
		addChild(cloud2)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func open () {
		guard !isOpen else {
			return
		}
		cloud1.run(SKAction.move(by: CGVector(dx: -300, dy: 0), duration: 1))
		cloud2.run(SKAction.move(by: CGVector(dx: 300, dy: 0), duration: 1))
		cloud3.run(SKAction.move(by: CGVector(dx: 200, dy: 0), duration: 1))
		self.isOpen = true
	}
	
	func close () {
		guard isOpen else {
			return
		}
		cloud1.run(SKAction.move(by: CGVector(dx: 300, dy: 0), duration: 1))
		cloud2.run(SKAction.move(by: CGVector(dx: -300, dy: 0), duration: 1))
		cloud3.run(SKAction.move(by: CGVector(dx: -200, dy: 0), duration: 1))
		self.isOpen = false
	}
	
}

