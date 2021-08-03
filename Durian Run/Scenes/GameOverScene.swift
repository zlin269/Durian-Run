//
//  GameOverScene.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/19.
//

import SpriteKit
import GameplayKit

class GameOverScene: MenuScene {
	init(size: CGSize, score: Double, seasons: Int, coins: Int) {
		super.init(size: size)
		
		if Int(score) > UserDefaults.int(forKey: .highScore) ?? 0 {
			UserDefaults.set(value: Int(score), forKey: .highScore)
		}
		if seasons > UserDefaults.int(forKey: .mostSeasons) ?? 0 {
			UserDefaults.set(value: seasons, forKey: .mostSeasons)
		}
		UserDefaults.set(value: UserDefaults.int(forKey: .coins) ?? 0 + coins, forKey: .coins)
		
		let scoreLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
		scoreLabel.text = "Score: " + String(Int(score))
		scoreLabel.fontSize = 200
		scoreLabel.fontColor = SKColor.black
		adjustLabelFontSizeToFitRect(labelNode: scoreLabel, rect: CGRect(origin: CGPoint(x: self.frame.midX, y: self.frame.midY + 270), size: CGSize(width: self.frame.width * 0.6, height: self.frame.height * 0.2)))
		scoreLabel.horizontalAlignmentMode = .center
		
		let coinLabel = SKLabelNode(fontNamed: "ChalkboardSE-Light")
		coinLabel.text = "Coins Collected: " + String(coins)
		coinLabel.fontSize = 120
		coinLabel.fontColor = SKColor.black
		coinLabel.position = CGPoint(x: frame.midX + scoreLabel.frame.width/2 - coinLabel.frame.width/2 - 5, y: frame.midY + 30)
		
		let seasonLabelIntro = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
		seasonLabelIntro.text = "Survived To The"
		seasonLabelIntro.fontSize = 120
		seasonLabelIntro.fontColor = SKColor.black
		seasonLabelIntro.position = CGPoint(x: frame.midX + scoreLabel.frame.width/2 - seasonLabelIntro.frame.width/2 - 5, y: frame.midY - 160)
		
		let seasonLabel = SKLabelNode(fontNamed: "SnellRoundhand-Black")
		let season = Season.init(rawValue: seasons%4 + 1)?.description
		let year = String(seasons / 4 + Calendar.current.component(.year, from: Date()))
		seasonLabel.text = season! + " of " + year
		seasonLabel.fontSize = 180
		seasonLabel.fontColor = SKColor.black
		seasonLabel.position = CGPoint(x: frame.midX + scoreLabel.frame.width/2 - seasonLabel.frame.width/2 - 5, y: frame.midY - 350)
		
		let restartIcon = SKSpriteNode(imageNamed: "restart")
		restartIcon.name = "restart"
		restartIcon.size = CGSize(width: 300, height: 300)
		restartIcon.position = CGPoint(x: frame.width - 300, y: frame.height - 200)
		
		let kule = SKSpriteNode(imageNamed: "kule")
		kule.position = CGPoint(x: frame.midX - 850, y: frame.midY + 20)
		
		let home = SKSpriteNode(imageNamed: "home")
		home.name = "home"
		home.position = CGPoint(x: frame.width - 300, y: 200)
		home.size = CGSize(width: 300, height: 300)
		
		addChild(seasonLabelIntro)
		addChild(seasonLabel)
		addChild(coinLabel)
		addChild(kule)
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
	
	func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode, rect:CGRect) {
		
		// Determine the font scaling factor that should let the label text fit in the given rectangle.
		let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)
		
		// Change the fontSize.
		labelNode.fontSize *= scalingFactor
		
		// Optionally move the SKLabelNode to the center of the rectangle.
		labelNode.position = CGPoint(x: rect.minX, y: rect.midY - labelNode.frame.height / 2.0)
	}
}
