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
		
		let winner = SKLabelNode(fontNamed: "Chalkduster")
		winner.text = "Game Over!"
		winner.fontSize = 200
		winner.fontColor = SKColor.brown
		winner.position = CGPoint(x: frame.midX, y: frame.midY)
		
		addChild(winner)
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
