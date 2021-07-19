//
//  GameOverScene.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/19.
//

import SpriteKit
import GameplayKit

class GameOverScene: MenuScene {
	
	
	var notificationLabel = SKLabelNode(text: "Game Over")
	
	override init(size: CGSize) {
		super.init(size: size)
		
		addChild(notificationLabel)
		notificationLabel.fontSize = 32.0
		notificationLabel.color = SKColor.white
		notificationLabel.fontName = "Thonburi-Bold"
		notificationLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		let gameScene = GameScene(size: size)
		gameScene.scaleMode = scaleMode
		
		let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
		view?.presentScene(gameScene, transition: reveal)
	
	}
}
