//
//  StartMenuScene.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/26.
//

import SpriteKit

class StartMenuScene: MenuScene {
	override init(size: CGSize) {
		super.init(size: size)
		
		let hello = SKLabelNode(fontNamed: "Chalkduster")
		hello.text = "Welcome! Little Durian."
		hello.fontSize = 180
		hello.fontColor = SKColor.brown
		hello.position = CGPoint(x: frame.midX, y: frame.midY + 200)
		
		
		let start = SKSpriteNode(imageNamed: "start")
		start.name = "start"
		start.size = CGSize(width: 300, height: 300)
		start.position = CGPoint(x: frame.midX, y: frame.midY - 100)
		
		addChild(hello)
		addChild(start)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		for t in touches {
			let touchedNode = atPoint(t.location(in: self))
			if touchedNode.name == "start" {
				let gameScene = GameScene(size: size)
				gameScene.scaleMode = scaleMode
				
				let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
				view?.presentScene(gameScene, transition: reveal)
			}
		}
		
		
		
	}
}
