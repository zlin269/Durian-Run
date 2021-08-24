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
			let newRecord = SKLabelNode(fontNamed: "Zapfino")
			newRecord.text = {()->String in switch UserDefaults.string(forKey: .language) {
            case "Chinese": return "新纪录！"
            case "English": return "New Record!"
            case "Thai": return "สถิติใหม่!"
            default: return "New Record!"
            }}()
			newRecord.fontColor = .red
			newRecord.fontSize = 70
			newRecord.position = CGPoint(x: 300, y: frame.height - 300)
			newRecord.zRotation = .pi / 4
			self.addChild(newRecord)
		}
		if seasons > UserDefaults.int(forKey: .mostSeasons) ?? 0 {
			UserDefaults.set(value: seasons, forKey: .mostSeasons)
		}
		UserDefaults.set(value: (UserDefaults.int(forKey: .coins) ?? 0) + coins, forKey: .coins)
		
		let scoreLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
		scoreLabel.text = {()->String in switch UserDefaults.string(forKey: .language) {
        case "Chinese": return "分数："
        case "English": return "Score: "
        case "Thai": return "คะแนน: "
        default: return "Score: "
        }}() + String(Int(score))
		scoreLabel.fontSize = 200
		scoreLabel.fontColor = .black
		adjustLabelFontSizeToFitRect(labelNode: scoreLabel, rect: CGRect(origin: CGPoint(x: self.frame.midX, y: self.frame.midY + 270), size: CGSize(width: self.frame.width * 0.6, height: self.frame.height * 0.2)))
		scoreLabel.horizontalAlignmentMode = .center
		
		let coinLabel = SKLabelNode(fontNamed: "ChalkboardSE-Light")
		coinLabel.text = {()->String in switch UserDefaults.string(forKey: .language) {
        case "Chinese": return "收集到金币："
        case "English": return "Coins Collected: "
        case "Thai": return "เหรียญสะสม: "
        default: return "Coins Collected: "
        }}() + String(coins)
		coinLabel.fontSize = 120
		coinLabel.fontColor = SKColor.black
		coinLabel.position = CGPoint(x: frame.midX + scoreLabel.frame.width/2 - coinLabel.frame.width/2 - 5, y: frame.midY + 30)
		
		let seasonLabelIntro = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
		seasonLabelIntro.text = {()->String in switch UserDefaults.string(forKey: .language) {
        case "Chinese": return "生存到"
        case "English": return "Survived To The"
        case "Thai": return "เอาชีวิตรอดไปยัง"
        default: return "Survived To The"
        }}()
		seasonLabelIntro.fontSize = 120
		seasonLabelIntro.fontColor = SKColor.black
		seasonLabelIntro.position = CGPoint(x: frame.midX + scoreLabel.frame.width/2 - seasonLabelIntro.frame.width/2 - 5, y: frame.midY - 160)
		
		let seasonLabel = SKLabelNode(fontNamed: "SnellRoundhand-Black")
        let season = Season.init(rawValue: seasons%4)
		let year = String(seasons / 4 + Calendar.current.component(.year, from: Date()))
		seasonLabel.text = {()->String in switch UserDefaults.string(forKey: .language) {
        case "Chinese": return year + "年的" + season!.chinese
        case "English": return season!.description + " of " + year
        case "Thai": return season!.thai + " " + year
        default: return season!.description + " of " + year
        }}()
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
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("scores")

        do {
            let data = try Data(contentsOf: path)
            if var scores = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Score] {
                scores.append(Score(name: "You", score: Int(score), seasons: seasons))
                scores.sort()
                let newdata = try NSKeyedArchiver.archivedData(withRootObject: scores, requiringSecureCoding: false)
                try newdata.write(to: path)
            }
        } catch {
            do {
                print("initializing scores data on disk")
                var scores = [Score(name: "Jack", score: 66666, seasons: 12),
                                  Score(name: "Alice", score: 23333, seasons: 6),
                                  Score(name: "Lawrence", score: 12345, seasons: 3)]
                scores.append(Score(name: "You", score: Int(score), seasons: seasons))
                scores.sort()
                let data = try NSKeyedArchiver.archivedData(withRootObject: scores, requiringSecureCoding: false)
                try data.write(to: path)
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
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
