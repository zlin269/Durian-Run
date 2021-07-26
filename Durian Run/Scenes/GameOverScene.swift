//
//  GameOverScene.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/19.
//

import SpriteKit
import GameplayKit

class GameOverScene: MenuScene {
	override init(size: CGSize) {
		super.init(size: size)
		
		let GOver = SKLabelNode(fontNamed: "Chalkduster")
		GOver.text = "GAME OVER!"
		GOver.fontSize = 200
		GOver.fontColor = SKColor.brown
		GOver.position = CGPoint(x: frame.midX, y: frame.midY + 270)
		
		let restart = SKLabelNode(fontNamed: "Chalkduster")
		restart.text = "Restart"
		restart.fontSize = 200
		restart.fontColor = SKColor.black
		restart.position = CGPoint(x: frame.midX, y: frame.midY - 380)
		
		let restartIcon = SKSpriteNode(imageNamed: "restart")
		restartIcon.name = "restart"
		restartIcon.size = CGSize(width: 300, height: 300)
		restartIcon.position = CGPoint(x: frame.midX, y: frame.midY)
		
		let kule = SKSpriteNode(imageNamed: "kule")
		kule.position = CGPoint(x: frame.midX - 800, y: frame.midY)
		
		let home = SKSpriteNode(imageNamed: "home")
		home.name = "home"
		home.position = CGPoint(x: frame.width - 300, y: 300)
		home.size = CGSize(width: 300, height: 300)
		
		
		addChild(kule)
		addChild(GOver)
		addChild(restart)
		addChild(restartIcon)
		addChild(home)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		for t in touches {
			let touchedNode = atPoint(t.location(in: self))
			if touchedNode.name == "restart" {
				let gameScene = GameScene(size: size)
				gameScene.scaleMode = scaleMode
				
				let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
				view?.presentScene(gameScene, transition: reveal)
			}
			if touchedNode.name == "home" {
				let menuScene = MenuScene(size: size)
				menuScene.scaleMode = scaleMode
				
				let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
				view?.presentScene(menuScene, transition: reveal)
			}
		}
		
		
	
	}
}
