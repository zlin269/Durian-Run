//
//  GameOverScene.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/19.
//

import SpriteKit
import GameplayKit

class GameOverScene: MenuScene {
	init(size: CGSize, score: Double) {
		super.init(size: size)
		
		let GOver = SKLabelNode(fontNamed: "Chalkduster")
		GOver.text = "GAME OVER!"
		GOver.fontSize = 200
		GOver.fontColor = SKColor.brown
		GOver.position = CGPoint(x: frame.midX, y: frame.midY + 270)
		
		let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
		scoreLabel.text = "Score: " + String(Int(score))
		scoreLabel.fontSize = 200.0 * (3.0 / (floor( log10( CGFloat(score)) ) + 1))
		scoreLabel.fontColor = SKColor.black
		scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - 380)
		
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
		addChild(scoreLabel)
		addChild(restartIcon)
		addChild(home)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		for t in touches {
			let touchedNode = atPoint(t.location(in: self))
			if touchedNode.name == "restart" {
				touchedNode.alpha = 0.7
				touchedNode.setScale(1.2)
			}
			if touchedNode.name == "home" {
				touchedNode.alpha = 0.7
				touchedNode.setScale(1.2)
			}
		}

	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches {
			let touchedNode = atPoint(t.location(in: self))
			if touchedNode.name == "restart" {
				touchedNode.alpha = 0.7
				touchedNode.setScale(1.2)
			} else {
				self.childNode(withName: "restart")?.alpha = 1
				self.childNode(withName: "restart")?.setScale(1)
			}
			if touchedNode.name == "home" {
				touchedNode.alpha = 0.7
				touchedNode.setScale(1.2)
			} else {
				self.childNode(withName: "home")?.alpha = 1
				self.childNode(withName: "home")?.setScale(1)
			}
		}
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
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let vc = storyboard.instantiateViewController(withIdentifier: "MainMenu")
				vc.view.frame = (self.view?.frame)!
				vc.view.layoutIfNeeded()
				UIView.transition(with: self.view!, duration: 0.3, options: .transitionCrossDissolve, animations:
									{
										self.view?.window?.rootViewController = vc
									}, completion: { completed in
									})
			
			}
		}
		
		
	
	}
}
