//
//  GameScene.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/16.
//
//

import SpriteKit
import GameplayKit

enum Season : Int {
	case season = 0, Spring, Summer, Fall, Winter

	var description: String {
		get {
			switch self {
			case .Spring:
				return "Spring"
			case .Summer:
				return "Summer"
			case .Fall:
				return "Fall"
			case .Winter:
				return "Winter"
			default:
				return String(rawValue)
			}
		}
	}
}


class GameScene: SKScene, SKPhysicsContactDelegate {
	
	static var sharedInstance = GameScene()
	
	// Season Info
	private var seasonInfo = SeasonInfo()
	
	// time var
    private var lastUpdateTime : TimeInterval = 0
	private var boostStartTime : TimeInterval = 0 // keep track of when boost will end
	private var justUnpaused : Bool = false // prevent loss of health during pause
	private var gameTime : TimeInterval = 0
    private var currentRainDropSpawnTime : TimeInterval = 0
    private var rainDropSpawnRate : TimeInterval = 0.1
	private var season : Season = Season.Spring {
		didSet {
			seasonInfo.nextSeason()
			isRaining = false
			switch season {
			case .Spring:
				scoreChangeIndicate("New Year +1500", yPos: frame.height - 700)
				score += 1500
				difficulty += 1
				seasonIndicator.color = UIColor.green
				sun.open()
			case .Summer:
				seasonIndicator.color = UIColor.cyan
				sun.open()
			case .Fall:
				seasonIndicator.color = UIColor.yellow
				sun.open()
			default: // .Winter
				seasonIndicator.color = UIColor.white
				sun.close()
			}
		}
	}
	private var seasonTimer : TimeInterval = 0 {
		didSet {
			if seasonTimer > 40 {
				nextSeason()
				seasonTimer = 0
			}
		}
	}
	
	// MARK: --Difficulty
	var difficulty : Double = 1
	
	// MARK: --Scoring
	var score : Double = 0 {
		didSet {
			scoreLabel.text = String(Int(score))
		}
	}
	lazy var scoreLabel = SKLabelNode(text: String(Int(score)))
	var seasonsPassed : Int = 0
	var coins : Int = 0 {
		didSet {
			coinLabel.text = String(coins)
		}
	}
	lazy var coinLabel = SKLabelNode(text: String(coins))
	
	// Boolean & Tracker
	var isRaining: Bool = false
	var isStorming: Bool = false
	var isActuallyPaused = false
    
	// Big game elements
	lazy var durian = Durian()
	lazy var platform = Platform(initial: true)
    lazy var platformLevel = Platform()
	lazy var sunshineBar = StatusBar(UIColor.red)
	lazy var waterBar = StatusBar(UIColor.blue)
	lazy var boostBar = StatusBar(UIColor.purple)
	lazy var sun = Sun()
	lazy var fertilizer = Fertilizer()
	lazy var supply = Supply()
	lazy var musicNode = SKAudioNode(fileNamed: "electronic.wav")
	lazy var gameSound = SKAudioNode(fileNamed: "coin.wav")
	
    lazy var platforms = [Platform]()
    lazy var platformLevels = [Platform]()
	lazy var factories = [Factory]()
	lazy var enemies = [Enemy]()
	lazy var raindrops = [Rain]()

	// platforms
	static var platformSpeed : CGFloat = 1000
    var platformLength = 10
	var platformGap : CGFloat {
		return GameScene.platformSpeed / 4
	}
    var platformPositionR: CGFloat = 0
    var levelLength = 2
    var levelGap = 2000
    var platformLevelPositionR: CGFloat = 0
    
	// buttons
	var pauseButton = Button(imageNamed: "pause")
	
	// Season Indicator
	var seasonIndicator = SKSpriteNode()
	
	// MARK: --Layers in Scene
	// Layers of nodes in the scene are determined by their zPosition
	// In this game we use the following convention:
	// Any background nodes has zPos < 0
	// Any gameplay related non-physics node has 0 <= zPos < 100
	// Any physics node has 100 <= zPos < 200
	// Any UI node has zPos >= 200
	override func didMove(to view: SKView) {
		
		GameScene.sharedInstance = self
		
		GameScene.platformSpeed = 1000
		
        print("Inside Gameplay Scene")
            createBackground()
		
		musicNode.autoplayLooped = true
		musicNode.run(SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .musicVolume) ?? 1), duration: 0))
		self.addChild(musicNode)
		
		gameSound.autoplayLooped = false
		gameSound.run(SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .gameVolume) ?? 1), duration: 0))
		self.addChild(gameSound)
		
		let boundary = Boundary()
		boundary.position = CGPoint(x: -300, y: -300)
		self.addChild(boundary)
		

		// long press gesture recognizer
		let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHappened))
		// self.view?.addGestureRecognizer(recognizer)
		recognizer.minimumPressDuration = 0.15
		
		let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
		self.view?.addGestureRecognizer(swipeUpRecognizer)
		swipeUpRecognizer.direction = .up
		
		let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
		self.view?.addGestureRecognizer(swipeDownRecognizer)
		swipeDownRecognizer.direction = .down
		
		let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
		self.view?.addGestureRecognizer(swipeRightRecognizer)
		swipeRightRecognizer.direction = .right
		
		let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
		self.view?.addGestureRecognizer(swipeLeftRecognizer)
		swipeLeftRecognizer.direction = .left
		
		// MARK: --gravity
		self.physicsWorld.contactDelegate = self
		self.physicsWorld.gravity = CGVector(dx: 0, dy: -30)
		
		// game elements
		
		durian.name = "durian"
		durian.state = .absorb
		durian.position = CGPoint(x: 800, y: 500)
		durian.zPosition = 100
		durian.size = CGSize(width: durian.size.width * 3, height: durian.size.height * 3)
		self.addChild(durian)
		
		platform.name = "platform"
		platform.position = CGPoint(x: 0, y: 50)
		platform.zPosition = 100
		platform.create(number: 30)
        platformPositionR = platform.position.x + platform.width
		self.addChild(platform)
        platforms.append(platform)
        
		
		sunshineBar.name = "health"
		sunshineBar.position = CGPoint(x: 1800, y: 1000)
		sunshineBar.zPosition = 200
		sunshineBar.setEmpty()
		sunshineBar.increase(by: 30)
		self.addChild(sunshineBar)
		
		waterBar.name = "water"
		waterBar.position = CGPoint(x: 1800, y: 900)
		waterBar.zPosition = 200
		waterBar.setEmpty()
		waterBar.increase(by: 30)
		self.addChild(waterBar)
		
		boostBar.name = "mana"
		boostBar.position = CGPoint(x: 1800, y: 800)
		boostBar.zPosition = 200
		boostBar.hasStacks = false
		//boostBar.setEmpty()
		self.addChild(boostBar)
		
		sun.name = "sun"
		sun.position = CGPoint(x: 1300, y: 800)
		sun.zPosition = 0
		sun.open()
		self.addChild(sun)
		
		pauseButton.name = "pauseButton"
		pauseButton.position = CGPoint(x: 80, y: 1100)
		pauseButton.zPosition = 200
		pauseButton.size = CGSize(width: 200, height: 200)
		pauseButton.anchorPoint = CGPoint(x: 0, y: 1) // anchor point at top left
		self.addChild(pauseButton)
		
		seasonIndicator = SKSpriteNode(color: UIColor.green, size: CGSize(width: 200, height: 200))
		seasonIndicator.anchorPoint = CGPoint(x: 0, y: 1) // anchor point at top left
		seasonIndicator.position = CGPoint(x: 80, y: 800)
		seasonIndicator.zPosition = 200
		self.addChild(seasonIndicator)
		
		scoreLabel.fontName = "Chalkduster"
		scoreLabel.fontSize = 200
		scoreLabel.fontColor = UIColor.red
		scoreLabel.position = CGPoint(x: frame.width / 2, y: frame.height - 200)
		scoreLabel.zPosition = 200
		self.addChild(scoreLabel)
		
		coinLabel.fontName = "Italic"
		coinLabel.fontSize = 100
		coinLabel.fontColor = UIColor.orange
		coinLabel.position = CGPoint(x: 400, y: frame.height - 200)
		coinLabel.zPosition = 200
		self.addChild(coinLabel)
    }
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "background2")
        
        for i in 0 ... 3 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -100
            
            background.anchorPoint = CGPoint.zero
            
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 0)
            addChild(background)
            
            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 15)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
        
        for i in 0 ... 3 {
            let background = SKSpriteNode(texture: backgroundTexture)
            background.zPosition = -100
            
            background.anchorPoint = CGPoint.zero
            
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 550)
            addChild(background)
            
            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 50)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
	
	// Long press event, handles absorb action
	@objc func longPressHappened (sender: UILongPressGestureRecognizer) {
		if durian.state != DurianState.boost {
			if sender.state == .began { durian.state = DurianState.absorb }
			if sender.state == .ended { durian.state = DurianState.normal }
		}
	}
	
	@objc func swipedUp (sender: UISwipeGestureRecognizer) {
		if !isPaused {
			if durian.inAir != 0 {
				durian.jump()
			} else {
				if waterBar.stacks > 0 {
					durian.jump()
					waterBar.stacks -= 1
				}
			}
		}
	}
	
	@objc func swipedDown (sender: UISwipeGestureRecognizer) {
		if !isPaused {
			durian.drop()
		}
	}
    
	@objc func swipedRight (sender: UISwipeGestureRecognizer) {
		if durian.state != DurianState.boost && boostBar.isMoreThanOrEqualTo(100) {
			durian.state = DurianState.boost
			boostStartTime = self.lastUpdateTime
			durian.run()
			let tempAudioNode = SKAudioNode(fileNamed: "powerup.wav")
			tempAudioNode.autoplayLooped = false
			self.addChild(tempAudioNode)
			tempAudioNode.run(SKAction.sequence([SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .gameVolume) ?? 1), duration: 0), SKAction.play(), SKAction.wait(forDuration: 3), SKAction.removeFromParent()]))
		}
	}
	
	@objc func swipedLeft (sender: UISwipeGestureRecognizer) {
		if durian.state != DurianState.boost {
			let tempAudioNode = SKAudioNode(fileNamed: "switch.wav")
			tempAudioNode.autoplayLooped = false
			self.addChild(tempAudioNode)
			tempAudioNode.run(SKAction.sequence([SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .gameVolume) ?? 1), duration: 0), SKAction.play(), SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
			if durian.state == .normal {
				durian.state = .absorb
			} else {
				durian.state = .normal
			}
		}
	}
	
	// MARK: --CONTACT DETECTION
	func didBegin(_ contact: SKPhysicsContact) {
		if (contact.bodyA.node is Platform && contact.bodyB.node is Durian) ||
            (contact.bodyB.node is Platform && contact.bodyA.node is Durian) {
			durian.inAir += 1
		}
        if (contact.bodyA.node is Fertilizer && contact.bodyB.node is Durian) || (contact.bodyB.node is Fertilizer && contact.bodyA.node is Durian) {
			fertilizer.getCollected()
			score += 100
			scoreChangeIndicate("Fertilizer Collected +100", yPos: frame.height - 500)
			boostBar.increase(by: 20)
        }
		if (contact.bodyA.node is Supply && contact.bodyB.node is Durian) || (contact.bodyB.node is Supply && contact.bodyA.node is Durian) {
			supply.getCollected()
			score += 100
			scoreChangeIndicate("Supply Collected +100", yPos: frame.height - 500)
			sunshineBar.increase(by: 20)
			waterBar.increase(by: 20)
		}
		if (contact.bodyA.node is Chaser && contact.bodyB.node is Durian) || (contact.bodyB.node is Chaser && contact.bodyA.node is Durian) {
			sunshineBar.setEmpty()
		}

		if contact.bodyA.node is Enemy && contact.bodyB.node is Durian {
			if durian.state == DurianState.boost {
				let b = contact.bodyA.node as! Enemy
				b.receiveDamage(1)
				score += 500
				scoreChangeIndicate("Eliminate Enemy +500", yPos: frame.height - 500)
				let tempAudioNode = SKAudioNode(fileNamed: "sword-attack.wav")
				tempAudioNode.autoplayLooped = false
				self.addChild(tempAudioNode)
				tempAudioNode.run(SKAction.sequence([SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .gameVolume) ?? 1), duration: 0), SKAction.play(), SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
			} else {
				if sunshineBar.stacks > 0 {
					sunshineBar.stacks -= 1
				} else {
					sunshineBar.decrease(by: 10 + (CGFloat(difficulty) * 5))
					waterBar.decrease(by: 10 + (CGFloat(difficulty) * 5))
				}
			}
		} else if contact.bodyB.node is Enemy && contact.bodyA.node is Durian {
			if durian.state == DurianState.boost {
				let b = contact.bodyB.node as! Enemy
				b.receiveDamage(1)
				score += 500
				scoreChangeIndicate("Eliminate Enemy +500", yPos: frame.height - 500)
				let tempAudioNode = SKAudioNode(fileNamed: "sword-attack.wav")
				tempAudioNode.autoplayLooped = false
				self.addChild(tempAudioNode)
				tempAudioNode.run(SKAction.sequence([SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .gameVolume) ?? 1), duration: 0), SKAction.play(), SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
			} else {
				if sunshineBar.stacks > 0 {
					sunshineBar.stacks -= 1
				} else {
					sunshineBar.decrease(by: 10 + (CGFloat(difficulty) * 5))
					waterBar.decrease(by: 10 + (CGFloat(difficulty) * 5))
				}
			}
		}
        
		if contact.bodyA.node is Boundary {
			contact.bodyB.node?.removeFromParent()
		} else if contact.bodyB.node is Boundary {
			contact.bodyA.node?.removeFromParent()
		}
		
		if contact.bodyA.node is Coin && contact.bodyB.node is Durian {
			let c = contact.bodyA.node as! Coin
			c.getCollected()
			let tempAudioNode = SKAudioNode(fileNamed: "coin.wav")
			tempAudioNode.autoplayLooped = false
			self.addChild(tempAudioNode)
			tempAudioNode.run(SKAction.sequence([SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .gameVolume) ?? 1), duration: 0), SKAction.play(), SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
			coins += 1
		} else if contact.bodyB.node is Coin && contact.bodyA.node is Durian{
			let c = contact.bodyB.node as! Coin
			c.getCollected()
			let tempAudioNode = SKAudioNode(fileNamed: "coin.wav")
			tempAudioNode.autoplayLooped = false
			self.addChild(tempAudioNode)
			tempAudioNode.run(SKAction.sequence([SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .gameVolume) ?? 1), duration: 0), SKAction.play(), SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
			coins += 1
		}
		
	}
	
	func didEnd(_ contact: SKPhysicsContact) {
		if (contact.bodyA.node is Platform && contact.bodyB.node is Durian) ||
            (contact.bodyB.node is Platform && contact.bodyA.node is Durian) {
			durian.inAir -= 1
		}
	}
    
	// Boost Mode and Attack handled at touchDown
    func touchDown(atPoint pos : CGPoint) {
		// let touchedNode = atPoint(pos)
		if isPaused  { return }
	}
    
//    // Not needed
//    func touchMoved(toPoint pos : CGPoint) {
//    }
    
	// Pause and Jump handled at touchUp
    func touchUp(atPoint pos : CGPoint) {
		let touchedNode = atPoint(pos)
		if touchedNode.name == "pauseButton" {
			if isPaused {
				unpause()
			} else {
				pause()
			}
		}
	}
	
	func pause() {
		print("Pausing")
		isActuallyPaused = true
		isPaused = true
		pauseButton.texture = SKTexture(imageNamed: "resume")
		justUnpaused = true
	}
	
	func unpause() {
		print("Unpausing")
		isActuallyPaused = false
		isPaused = false
		pauseButton.texture = SKTexture(imageNamed: "pause")
		justUnpaused = true
	}
    
	// ------------ No Need to Modify Any of the Touches ------------
	
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
	// ------------ No Need to Modify Any of the Touches ------------
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
		if isActuallyPaused {
			pause()
		}
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        var dt = currentTime - self.lastUpdateTime
		
		// Do not update status bars the first frame after unpause
		// Otherwise health bar drops by a lot (because its based on dt)
		// Unpaused
		if justUnpaused {
			justUnpaused = false
			dt = 0
		}
		
		// MARK: --Platforms
        // Platform move
        if(platforms[0].position.x + platforms[0].width < 0){
        // remove platform that out of scene
			platforms[0].removeFromParent()
            platforms.remove(at: 0)
        }
        
        if (platformPositionR < frame.width){
        // create new platform
            platform = Platform()
			platform.create(number: (platformLength + Int(arc4random_uniform(20))) * Int(arc4random_uniform(2)) + 2)
			platform.position = CGPoint(x:CGFloat(frame.width) + ((season == .Spring || season == .Summer) ? platformGap + CGFloat(Int(arc4random_uniform(400))) : 0), y: ((season == .Spring || season == .Summer) ? CGFloat(arc4random_uniform(100)) : 0) + 50)
            platform.zPosition = 100
            platformPositionR = platform.position.x + platform.width
			platform.name = "platform"
            self.addChild(platform)
            platforms.append(platform)
			if season == .Spring || season == .Summer {
				Coin.spawnCoinsRainbow(CGPoint(x: platform.position.x - platformGap, y: 680), self)
			}
        }
        
        for p in platforms{
			p.move(speed: GameScene.platformSpeed, dt)
        }
        
		platformPositionR = platformPositionR - GameScene.platformSpeed * CGFloat(dt)
        
		// PlatformLevel move
		if !platformLevels.isEmpty && platformLevels[0].position.x + platformLevels[0].width < 0 {
			// remove platform that out of scene
			platformLevels[0].removeFromParent()
			platformLevels.remove(at: 0)
		}
		
		for pl in platformLevels{
			pl.move(speed: GameScene.platformSpeed, dt)
		}
		
		platformLevelPositionR = platformLevelPositionR - CGFloat(dt) * GameScene.platformSpeed
		
		if fertilizer.inGame {
			fertilizer.move(speed: GameScene.platformSpeed, dt)
		}		
		
		// MARK: --Enemies
		if	!enemies.isEmpty && (enemies[0].position.x < -200 || enemies[0].position.y < -200) {
			enemies[0].selfDestruction()
			enemies.removeFirst()
		}
		for e in enemies {
			e.move(dt)
		}
		
		gameTime += dt
		if durian.state != DurianState.boost {
			sunshineBar.decrease(by: CGFloat(dt * difficulty))
			waterBar.decrease(by: CGFloat(dt * difficulty))
		}
		
		// Scoring Update
		score += dt * Double(GameScene.platformSpeed) / 15
		
		// MARK: --Boost
		if durian.state == DurianState.boost  {
			boostBar.decrease(by: CGFloat(dt) * 10)
			if boostBar.isEmpty() {
				durian.state = .normal
				durian.run()
			}
		}
		
		// MARK: --Season Change
		seasonTimer += dt
		
		// MARK: --Health Bar
		if sunshineBar.isEmpty() || waterBar.isEmpty() {
			displayGameOver()
		}
		
		// MARK: --Death On Falling
		if durian.position.y < 0 || self.childNode(withName: "durian") == nil {
			displayGameOver()
		}
		
		if durian.position.x < 0 {
			self.displayGameOver()
		} else if durian.position.x < 800 {
			durian.run(SKAction.moveBy(x: 0.5, y: 0, duration: dt))
		} else if durian.position.x > 800 {
			durian.run(SKAction.moveBy(x: -2, y: 0, duration: dt))
		}
        
		
		// MARK: --Absorbtion Related
		if durian.state == DurianState.absorb {
			if sun.isOpen {
				sunshineBar.increase(by: CGFloat(dt * 10))
			}
			if isRaining {
				waterBar.increase(by: CGFloat(dt * 10))
			}
			for f in factories {
				if abs(f.position.x - durian.position.x) < 300 {
					sunshineBar.decrease(by: CGFloat(dt * 25))
				}
			}
			if isStorming {
				sunshineBar.decrease(by: CGFloat(dt * 10))
				waterBar.increase(by: CGFloat(dt * 30))
			}
		}
		if durian.state == DurianState.boost {
			sunshineBar.increase(by: CGFloat(dt * 20))
			waterBar.increase(by: CGFloat(dt * 20))
		}
		
		// MARK: --Collectable
		if fertilizer.inGame && (fertilizer.position.x < -100 || fertilizer.position.y < -100) {
			fertilizer.removeFromParent()
			fertilizer.inGame = false
		}
		if	!raindrops.isEmpty && !raindrops[0].inGame {
			raindrops.removeFirst()
		}
	
		
		// MARK: Random Events Generation
		let epsilon = 0.1
		if abs((Double(gameTime) - Double(Int(gameTime)))) < epsilon {
			let num = arc4random_uniform(200)
			if num <= 1 {
				spawnFertilizer()
			}
			switch season {
			case .Spring:
				if 1 < num && num <= 10 {
					spawnFactory()
				}
				break
			case .Summer:
				if 1 < num && num <= 8 {
					spawnFactory()
				}
				break
			case .Fall:
				if 1 < num && num <= 20 && enemies.count == 0 {
					spawnBugs(Int(arc4random_uniform(5)))
				}
				break
			case .Winter:
				if 1 < num && num <= 20 && enemies.count == 0 {
					spawnBugs(Int(arc4random_uniform(5)))
				}
				break
			default:
				break
			}
			
		}
		
		switch season {
		case .Spring:
			
			if sun.isOpen && seasonTimer > seasonInfo.sunSetTime! && seasonTimer < seasonInfo.sunSetTime! + seasonInfo.sunSetDuration!  {
				sun.close()
			}
			if !sun.isOpen && seasonTimer > seasonInfo.sunSetTime! + seasonInfo.sunSetDuration! {
				sun.open()
			}
			if seasonTimer > seasonInfo.rainStartTime[0] && seasonTimer < seasonInfo.rainStartTime[0] + seasonInfo.rainDuration! {
				isRaining = true
			} else if seasonTimer > seasonInfo.rainStartTime[0] + seasonInfo.rainDuration! {
				isRaining = false
			}
			if seasonTimer > seasonInfo.rainStartTime[1] && seasonTimer < seasonInfo.rainStartTime[1] + seasonInfo.rainDuration! {
				isRaining = true
			} else if seasonTimer > seasonInfo.rainStartTime[1] + seasonInfo.rainDuration! {
				isRaining = false
			}
			break
		case .Summer:
			if sun.isOpen && seasonTimer > seasonInfo.sunSetTime! && seasonTimer < seasonInfo.sunSetTime! + seasonInfo.sunSetDuration!  {
				sun.close()
			}
			if !sun.isOpen && seasonTimer > seasonInfo.sunSetTime! + seasonInfo.sunSetDuration! && !isStorming {
				sun.open()
			}
			if seasonTimer > seasonInfo.rainStartTime[0] && seasonTimer < seasonInfo.rainStartTime[0] + seasonInfo.rainDuration! {
				isRaining = true
			} else if seasonTimer > seasonInfo.rainStartTime[0] + seasonInfo.rainDuration! && !isStorming {
				isRaining = false
			}
			if !isStorming && seasonTimer > seasonInfo.stormTime! && seasonTimer < seasonInfo.stormTime! + seasonInfo.stormDuration! {
				startStorm()
			}
			break
		case .Fall:
			if sun.isOpen && seasonTimer > seasonInfo.sunSetTime! && seasonTimer < seasonInfo.sunSetTime! + seasonInfo.sunSetDuration!  {
				sun.close()
			}
			if !sun.isOpen && seasonTimer > seasonInfo.sunSetTime! + seasonInfo.sunSetDuration! {
				sun.open()
			}
			
			if seasonTimer > seasonInfo.supplySpawnTime[0] && seasonInfo.suppliesSpawned == 0 {
				spawnSupply()
			}
			if seasonTimer > seasonInfo.supplySpawnTime[1] && seasonInfo.suppliesSpawned == 1 {
				spawnSupply()
			}
			if (platformLevelPositionR < frame.width){
				// create new platform
				platformLevel = Platform()
				platformLevel.create(number: levelLength + Int(arc4random_uniform(5)))
				platformLevel.position = CGPoint(x:CGFloat(frame.width) + CGFloat(levelGap + Int(arc4random_uniform(500))), y:500)
				platformLevel.zPosition = 100
				platformLevelPositionR = platformLevel.position.x + platformLevel.width
				platformLevel.name = "platformLevel"
				self.addChild(platformLevel)
				platformLevels.append(platformLevel)
				Coin.spawnCoinsLine(3 ,CGPoint(x: platformLevel.position.x + 100, y: 680), self)
				Coin.spanwCoinsDrop(CGPoint(x: platformLevel.position.x + platformLevel.width + 200, y: 1100), self)
			}
			break
		case .Winter:
			if seasonTimer > seasonInfo.supplySpawnTime[0] && seasonInfo.suppliesSpawned == 0 {
				spawnSupply()
			}
			if seasonTimer > seasonInfo.supplySpawnTime[1] && seasonInfo.suppliesSpawned == 1 {
				spawnSupply()
			}
			if (platformLevelPositionR < frame.width){
				// create new platform
				platformLevel = Platform()
				platformLevel.create(number: levelLength + Int(arc4random_uniform(3)))
				platformLevel.position = CGPoint(x:CGFloat(frame.width) + CGFloat(levelGap + Int(arc4random_uniform(500))), y:460)
				platformLevel.zPosition = 100
				platformLevelPositionR = platformLevel.position.x + platformLevel.width
				platformLevel.name = "platformLevel"
				self.addChild(platformLevel)
				platformLevels.append(platformLevel)
			}
			if !isStorming && seasonTimer > seasonInfo.stormTime! && seasonTimer < seasonInfo.stormTime! + seasonInfo.stormDuration! {
				startStorm()
			}
			break
		default:
			break
		}
		
		if isRaining {
			// Update the spawn timer
			currentRainDropSpawnTime += dt

			if currentRainDropSpawnTime > rainDropSpawnRate {
			  currentRainDropSpawnTime = 0
			  spawnRaindrop()
			}
		}
		

		// MARK: --DEBUG INFO
//		print("game time:", gameTime)
//		print("durian state:", durian.state)
//		print("in air:", durian.inAir)
		print("Season Timer: ", seasonTimer)
		
		GameScene.platformSpeed += CGFloat(dt * 2)
		print("Speed: ", GameScene.platformSpeed)

        
        self.lastUpdateTime = currentTime
    }
	
	// Creates a game over scene
	func displayGameOver() {
		
		musicNode.run(SKAction.stop())
		
		let gameOverScene = GameOverScene(size: size, score: score, seasons: seasonsPassed, coins: coins)
		gameOverScene.scaleMode = scaleMode
		
		let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
		view?.presentScene(gameOverScene, transition: reveal)
	}
	
	
	// MARK: --Manage Pollution
	func spawnFactory () {
		let factory = Factory()
		factory.position = CGPoint(x: self.frame.width + 200, y: 400)
		factory.zPosition = -50
		if factory.position.x - 500 < factories.last?.position.x ?? 500 {
			factory.removeFromParent()
			return
		}
		self.addChild(factory)
		factories.append(factory)
		factory.run(SKAction.moveTo(x: -200, duration: TimeInterval((self.size.width + 400) / GameScene.platformSpeed)), completion: {
			factory.removeFromParent()
			self.factories.removeFirst()
		})
	}
	
	func spawnFertilizer () {
		guard !fertilizer.inGame else {
			return
		}
		fertilizer = Fertilizer()
		fertilizer.name = "fertilizer"
		fertilizer.inGame = true
		fertilizer.position = CGPoint(x: self.frame.width + 400, y: 700)
		fertilizer.zPosition = 100
		self.addChild(fertilizer)
	}
	
	func spawnSupply () {
		seasonInfo.suppliesSpawned += 1
		supply = Supply()
		supply.inGame = true
		supply.position = CGPoint(x: self.frame.width + 400, y: 700)
		supply.zPosition = 100
		supply.run(SKAction.moveTo(x: -200, duration: TimeInterval((self.size.width + 400) / GameScene.platformSpeed)), completion: {
			self.supply.removeFromParent()
		})
		self.addChild(supply)
		print("supply spawned")
	}
	
	func spawnBugs (_ num: Int) {
		switch num {
		case 0:
			let bug1 = Bug()
			bug1.position = CGPoint(x: self.frame.width , y: 600)
			bug1.zPosition = 100
			enemies.append(bug1)
			self.addChild(bug1)
			let bug2 = Bug()
			bug2.position = CGPoint(x: self.frame.width + 800 + GameScene.platformSpeed / 10, y: 600)
			bug2.zPosition = 100
			enemies.append(bug2)
			self.addChild(bug2)
			break
		case 1:
			let bug1 = Bug()
			bug1.position = CGPoint(x: self.frame.width + 200, y: 600)
			bug1.zPosition = 100
			enemies.append(bug1)
			self.addChild(bug1)
			let bug2 = Bug()
			bug2.position = CGPoint(x: self.frame.width + 400 + GameScene.platformSpeed / 10, y: 600)
			bug2.zPosition = 100
			enemies.append(bug2)
			self.addChild(bug2)
			break
		case 2:
			let bug1 = Bug()
			bug1.position = CGPoint(x: self.frame.width + 200, y: 600)
			bug1.zPosition = 100
			enemies.append(bug1)
			self.addChild(bug1)
			let bug2 = Bug()
			bug2.position = CGPoint(x: self.frame.width + 200, y: 900)
			bug2.zPosition = 100
			enemies.append(bug2)
			self.addChild(bug2)
			break
		case 3:
			let fly = Fly()
			fly.position = CGPoint(x: self.frame.width + 200, y: 800)
			fly.zPosition = 100
			enemies.append(fly)
			self.addChild(fly)
		default:
			let bug = Bug()
			bug.position = CGPoint(x: self.frame.width + 200, y: 600)
			bug.zPosition = 100
			enemies.append(bug)
			self.addChild(bug)
		}
			
	}
	
	func nextSeason() {
		score += 800
		scoreChangeIndicate("New Season +800", yPos: frame.height - 500)
		seasonsPassed += 1
		if season == .Spring {
			season = .Summer
		} else if season == .Summer {
			season = .Fall
		} else if season == .Fall {
			season = .Winter
		} else if season == .Winter {
			season = .Spring
		}
	}
    
    func spawnRaindrop() {
		
		let raindrop = Rain()
		raindrop.name = "raindrop"
		let xPosition = CGFloat(arc4random_uniform(UInt32(self.frame.width)))
        let yPosition = size.height + raindrop.size.height

        raindrop.position = CGPoint(x: xPosition, y: yPosition)
		raindrop.run(SKAction.moveTo(y: -100, duration: 0.8), completion: {
			raindrop.removeFromParent()
			raindrop.inGame = false
		})
		raindrops.append(raindrop)
        self.addChild(raindrop)
      }
	
	func lightening () {
		let flash = SKSpriteNode(color: UIColor.black, size: self.frame.size)
		flash.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
		flash.zPosition = 150
		self.addChild(flash)
		flash.alpha = 0
		flash.run(SKAction.sequence([SKAction.fadeAlpha(to: 0.8, duration: 2),
									 SKAction.fadeAlpha(to: 0, duration: 0.1),
									 SKAction.colorize(with: UIColor.white, colorBlendFactor: 0, duration: 0.1),
									 SKAction.fadeAlpha(to: 1, duration: 0.1),
									 SKAction.fadeAlpha(to: 0, duration: 0.7)]), completion: {
										flash.removeFromParent()
									})
	}
	
	func startStorm () {
		isStorming = true
		isRaining = true
		sun.close()
		let thunder = SKAudioNode(fileNamed: "thunder.wav")
		thunder.autoplayLooped = false
		thunder.run(SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .musicVolume) ?? 0), duration: 0))
		let flash = SKSpriteNode(color: UIColor.black, size: self.frame.size)
		flash.addChild(thunder)
		thunder.run(SKAction.play())
		flash.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
		flash.zPosition = 150
		self.addChild(flash)
		flash.alpha = 0
		flash.run(SKAction.sequence([SKAction.fadeAlpha(to: 0.8, duration: 2),
									 SKAction.fadeAlpha(to: 0, duration: 0.1),
									 SKAction.colorize(with: UIColor.white, colorBlendFactor: 0, duration: 0.1),
									 SKAction.fadeAlpha(to: 1, duration: 0.1),
									 SKAction.fadeAlpha(to: 0, duration: 0.7),
									 SKAction.colorize(with: UIColor.black, colorBlendFactor: 0, duration: 0),
									 SKAction.fadeAlpha(to: 0.5, duration: 2),
									 SKAction.fadeAlpha(to: 0.8, duration: 2),
									 SKAction.fadeAlpha(to: 0, duration: 0.1),
									 SKAction.colorize(with: UIColor.white, colorBlendFactor: 0, duration: 0.1),
									 SKAction.fadeAlpha(to: 1, duration: 0.1),
									 SKAction.fadeAlpha(to: 0, duration: 0.7),
									 SKAction.colorize(with: UIColor.black, colorBlendFactor: 0, duration: 0),
									 SKAction.fadeAlpha(to: 0.5, duration: 1),
									 SKAction.fadeAlpha(by: 0, duration: 1)]), completion: {
										flash.removeFromParent()
										self.isStorming = false
										self.isRaining = false
										self.sun.open()
									})
	}
	
	func scoreChangeIndicate (_ text: String, yPos: CGFloat) {
		let scoreChangeLabel = SKLabelNode(text: text)
		scoreChangeLabel.fontName = "Chalkduster"
		scoreChangeLabel.fontSize = 100
		scoreChangeLabel.fontColor = UIColor.red
		scoreChangeLabel.position = CGPoint(x: frame.width / 2, y: yPos)
		scoreChangeLabel.zPosition = 200
		self.addChild(scoreChangeLabel)
		scoreChangeLabel.run(SKAction.moveTo(y: frame.height - 300, duration: 1))
		scoreChangeLabel.run(SKAction.fadeOut(withDuration: 1), completion: {
			scoreChangeLabel.removeFromParent()
		})
	}
}
