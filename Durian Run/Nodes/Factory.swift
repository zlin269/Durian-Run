//
//  Factory.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/20.
//

import SpriteKit

class Factory: SKNode {
	
	override init() {
		super.init()
		let factory = SKSpriteNode(imageNamed: "house")
		let chimeny = SKSpriteNode(imageNamed: "tower")
		let explanation = SKLabelNode(text: "This is a FACTORY")
		factory.position = CGPoint(x: 0, y: 0)
		factory.zPosition = 0
		chimeny.position = CGPoint(x: 30, y: 30)
		chimeny.zPosition = -10
		explanation.fontSize = 80
		explanation.fontColor = UIColor.white
		explanation.position = CGPoint(x: 0, y: 0)
		explanation.zPosition = 10
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
