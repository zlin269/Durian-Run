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
		
		if seasons > UserDefaults.int(forKey: .mostSeasons)! {
			UserDefaults.set(value: seasons, forKey: .mostSeasons)
		}
		UserDefaults.set(value: (UserDefaults.int(forKey: .coins)!) + coins, forKey: .coins)
        
        var kule = SKSpriteNode(imageNamed: "kule")
        kule.position = CGPoint(x: frame.midX - 850, y: frame.midY + 20)
        
        let scoreLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        scoreLabel.fontSize = 220
        scoreLabel.fontColor = .healthColor
        scoreLabel.zRotation = .pi / 80

        UserDefaults.set(value: (UserDefaults.int(forKey: .totalScore)!) + Int(score), forKey: .totalScore)
        UserDefaults.set(value: (UserDefaults.int(forKey: .totalTime)!) + seasons, forKey: .totalTime)
        UserDefaults.set(value: (UserDefaults.int(forKey: .cppoint)!) + coins, forKey: .cppoint)
        
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.text = "\(Int(score))"
        if Int(score) > UserDefaults.int(forKey: .highScore)! {
            UserDefaults.set(value: Int(score), forKey: .highScore)
            let newRecord = SKSpriteNode(imageNamed: "newrecord")
            newRecord.position = CGPoint(x: frame.midX, y: frame.height - 400)
            newRecord.zRotation = .pi / 100
            newRecord.setScale(3)
            self.addChild(newRecord)
            scoreLabel.fontSize = 180
            scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
            kule = SKSpriteNode(imageNamed: "durianlove")
            kule.setScale(2.5)
            kule.position = CGPoint(x: frame.midX - 850, y: frame.midY + 20)
        }
		
//		let coinLabel = SKLabelNode(fontNamed: "ChalkboardSE-Light")
//		coinLabel.text = {()->String in switch UserDefaults.string(forKey: .language) {
//        case "Chinese": return "收集到金币："
//        case "English": return "Coins Collected: "
//        case "Thai": return "เหรียญสะสม: "
//        default: return "Coins Collected: "
//        }}() + String(coins)
//		coinLabel.fontSize = 120
//		coinLabel.fontColor = SKColor.black
//		coinLabel.position = CGPoint(x: frame.midX + scoreLabel.frame.width/2 - coinLabel.frame.width/2 - 5, y: frame.midY + 30)
		
//		let seasonLabelIntro = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
//		seasonLabelIntro.text = {()->String in switch UserDefaults.string(forKey: .language) {
//        case "Chinese": return "生存到"
//        case "English": return "Survived To The"
//        case "Thai": return "เอาชีวิตรอดไปยัง"
//        default: return "Survived To The"
//        }}()
//		seasonLabelIntro.fontSize = 120
//		seasonLabelIntro.fontColor = SKColor.black
//		seasonLabelIntro.position = CGPoint(x: frame.midX + scoreLabel.frame.width/2 - seasonLabelIntro.frame.width/2 - 5, y: frame.midY - 160)
		
//		let seasonLabel = SKLabelNode(fontNamed: "SnellRoundhand-Black")
//        let season = Season.init(rawValue: seasons%4)
//		let year = String(seasons / 4 + Calendar.current.component(.year, from: Date()))
//		seasonLabel.text = {()->String in switch UserDefaults.string(forKey: .language) {
//        case "Chinese": return year + "年的" + season!.chinese
//        case "English": return season!.description + " of " + year
//        case "Thai": return season!.thai + " " + year
//        default: return season!.description + " of " + year
//        }}()
//		seasonLabel.fontSize = 180
//		seasonLabel.fontColor = SKColor.black
//		seasonLabel.position = CGPoint(x: frame.midX + scoreLabel.frame.width/2 - seasonLabel.frame.width/2 - 5, y: frame.midY - 350)
//
		let restartIcon = SKSpriteNode(imageNamed: "pink button")
        restartIcon.setScale(2.7)
		restartIcon.name = "restart"
        restartIcon.position = CGPoint(x: frame.midX, y: 140)
        let restarttext = SKLabelNode(text: {()->String in switch UserDefaults.string(forKey: .language) {
        case "Chinese": return "再玩一次"
        case "English": return "Play Again"
        case "Thai": return "เล่นอีกครั้ง"
        default: return "再玩一次"
        }}())
        restarttext.zPosition = 20
        restarttext.fontColor = .yellow
        restarttext.fontSize = 100
        restarttext.fontName = "AlNile-Bold"
        adjustLabelFontSizeToFitRect(labelNode: restarttext, rect: CGRect(origin: .zero, size: CGSize(width: restartIcon.frame.width * 0.2, height: restartIcon.frame.height * 0.2)))
        restarttext.position = CGPoint(x: 0, y: -10)
        restartIcon.addChild(restarttext)
        
		
        let nameLabel = SKLabelNode(text: UserDefaults.string(forKey: .username))
        nameLabel.fontColor = .healthColor
        nameLabel.position = CGPoint(x: frame.midX, y: frame.midY - 186)
        nameLabel.horizontalAlignmentMode = .center
        nameLabel.fontSize = 120
        nameLabel.fontName = "AvenirNext-Medium"
        adjustLabelFontSizeToFitRect(labelNode: nameLabel, rect: CGRect(origin: nameLabel.frame.origin, size: CGSize(width: 240, height: 80)))

		let home = SKSpriteNode(imageNamed: "back")
		home.name = "home"
        home.position = CGPoint(x: 110, y: frame.height - 143)
        home.size = CGSize(width: 100, height: 100)
        
        let leaderBoard = SKSpriteNode(imageNamed: "trophyDark")
        leaderBoard.name = "leaderBoard"
        leaderBoard.position = CGPoint(x: frame.width - 215, y: frame.height - 138)
        leaderBoard.size = CGSize(width: 110, height: 110)
		
		
//		addChild(seasonLabelIntro)
//		addChild(seasonLabel)
//		addChild(coinLabel)
        addChild(nameLabel)
		addChild(kule)
		addChild(scoreLabel)
		addChild(restartIcon)
		addChild(home)
        addChild(leaderBoard)
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("scores")

        if score > 0 {
        do {
            let data = try Data(contentsOf: path)
            if var scores = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Score] {
                scores.append(Score(name: UserDefaults.string(forKey: .username)!, score: Int(score), seasons: seasons, avatar: UserDefaults.string(forKey: .avatar)!))
                scores.sort()
                let newdata = try NSKeyedArchiver.archivedData(withRootObject: scores, requiringSecureCoding: false)
                try newdata.write(to: path)
            }
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		for t in touches {
			let touchedNode = atPoint(t.location(in: self))
			if touchedNode.name == "restart" {
				touchedNode.alpha = 0.7
                touchedNode.setScale(3)
                touchedNode.run(SKAction.wait(forDuration: 0.3), completion: {
                    let gameScene = GameScene(size: self.size)
                    gameScene.scaleMode = self.scaleMode
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    self.view?.presentScene(gameScene, transition: reveal)
                })
			}
			if touchedNode.name == "home" {
				touchedNode.alpha = 0.7
				touchedNode.setScale(1.2)
			}
            if touchedNode.name == "leaderBoard" {
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
                touchedNode.setScale(3)
			} else {
				self.childNode(withName: "restart")?.alpha = 1
                self.childNode(withName: "restart")?.setScale(2.7)
			}
			if touchedNode.name == "home" {
				touchedNode.alpha = 0.7
				touchedNode.setScale(1.2)
			} else {
				self.childNode(withName: "home")?.alpha = 1
				self.childNode(withName: "home")?.setScale(1)
			}
            if touchedNode.name == "leaderBoard" {
                touchedNode.alpha = 0.7
                touchedNode.setScale(1.2)
            } else {
                self.childNode(withName: "leaderBoard")?.alpha = 1
                self.childNode(withName: "leaderBoard")?.setScale(1)
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
            if touchedNode.name == "leaderBoard" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LeaderBoard")
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
		

	}
}
