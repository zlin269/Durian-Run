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
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
	// time var
    private var lastUpdateTime : TimeInterval = 0
	private var boostStartTime : TimeInterval = 0 // keep track of when boost will end
	private var sunStartTime : TimeInterval = 0
	private var justUnpaused : Bool = false // prevent loss of health during pause
	private var gameTime : TimeInterval = 0
    private var currentRainDropSpawnTime : TimeInterval = 0
    private var rainDropSpawnRate : TimeInterval = 0.1
	private var season : Season = Season.Spring {
		didSet {
			switch season {
			case .Spring:
				seasonIndicator.color = UIColor.green
				isRaining = true
			case .Summer:
				seasonIndicator.color = UIColor.cyan
				isRaining = true
			case .Fall:
				seasonIndicator.color = UIColor.yellow
				isRaining = false
			default:
				seasonIndicator.color = UIColor.white
				isRaining = false
			}
		}
	}
	private var seasonTimer : TimeInterval = 0 {
		didSet {
			if seasonTimer > 45 {
				nextSeason()
				seasonTimer = 0
			}
		}
	}
	
	// Boolean
	var isRaining: Bool = false
    
	// Big game elements
	lazy var durian = Durian()
	lazy var platform = Platform()
	lazy var sunshineBar = StatusBar(UIColor.red)
	lazy var waterBar = StatusBar(UIColor.blue)
	lazy var boostBar = StatusBar(UIColor.purple)
    lazy var platformLevel = Platform()
	lazy var statusBar = StatusBar(UIColor.red)
	lazy var boostBar = StatusBar(UIColor.blue)
	lazy var sun = Sun()
	lazy var fertilizer = Fertilizer()
    
	
    lazy var platforms = [Platform]()
    lazy var platformLevels = [Platform]()
	lazy var factories = [Factory]()
	lazy var enemies = [Enemy]()
	lazy var raindrops = [Rain]()

	// platforms
	static var platformSpeed : CGFloat = 12
    var platformLength = 10
    var platformGap = 250
    var platformPositionR: CGFloat = 0
    var levelLength = 2
    var levelGap = 2000
    var platformLevelPositionR: CGFloat = 0
    
	// buttons
	var boostButton = Button(imageNamed: "boost")
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
        
        print("Inside Gameplay Scene")
            createBackground()

		season = .Summer
		
		// long press gesture recognizer
		let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHappened))
		self.view?.addGestureRecognizer(recognizer)
		
		// MARK: --gravity
		self.physicsWorld.contactDelegate = self
		self.physicsWorld.gravity = CGVector(dx: 0, dy: -15)
		
		// game elements
		
		durian.name = "durian"
		durian.position = CGPoint(x: 300, y: 500)
		durian.zPosition = 100
		durian.size = CGSize(width: durian.size.width * 3, height: durian.size.height * 3)
		self.addChild(durian)
		
		platform.name = "platform"
		platform.position = CGPoint(x: 0, y: 50)
		platform.zPosition = 100
		platform.create(number: 16)
        platformPositionR = platform.position.x + platform.width
		self.addChild(platform)
        platforms.append(platform)
        
        platformLevel.name = "platformLevel"
        platformLevel.position = CGPoint(x: 1500, y: 520)
        platformLevel.zPosition = 100
        platformLevel.create(number: 4)
        platformLevelPositionR = platformLevel.position.x + platformLevel.width
        self.addChild(platformLevel)
        platformLevels.append(platformLevel)
        
		
		sunshineBar.name = "health"
		sunshineBar.position = CGPoint(x: 1800, y: 1000)
		sunshineBar.zPosition = 200
		self.addChild(sunshineBar)
		
		waterBar.name = "water"
		waterBar.position = CGPoint(x: 1800, y: 900)
		waterBar.zPosition = 200
		waterBar.setEmpty()
		waterBar.increase(by: 50)
		self.addChild(waterBar)
		
		boostBar.name = "mana"
		boostBar.position = CGPoint(x: 1800, y: 800)
		boostBar.zPosition = 200
		boostBar.setEmpty()
		self.addChild(boostBar)
		
		sun.name = "sun"
		sun.position = CGPoint(x: 1300, y: 800)
		sun.zPosition = 0
		self.addChild(sun)
		
		boostButton.name = "boostButton"
		boostButton.position = CGPoint(x: 2350, y: 500)
		boostButton.zPosition = 200
		boostButton.anchorPoint = CGPoint(x: 1, y: 1) // anchor point at bottom top
		self.addChild(boostButton)
		
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
    
	// MARK: --CONTACT DETECTION
	func didBegin(_ contact: SKPhysicsContact) {
		if (contact.bodyA.node is Platform && contact.bodyB.node is Durian) ||
            (contact.bodyB.node is Platform && contact.bodyA.node is Durian) {
			durian.inAir += 1
		}
        if (contact.bodyA.node?.name == "fertilizer" && contact.bodyB.node?.name == "durian") || (contact.bodyB.node?.name == "fertilizer" && contact.bodyA.node?.name == "durian") {
			fertilizer.getCollected()
			boostBar.increase(by: 50)
        }
		if contact.bodyA.node?.name == "bug" && contact.bodyB.node?.name == "durian" {
			if durian.state == DurianState.boost {
				let b = contact.bodyA.node as! Bug
				b.receiveDamage(1)
			} else {
				sunshineBar.decrease(by: 30)
				boostBar.decrease(by: 50)
			}
		} else if contact.bodyB.node?.name == "bug" && contact.bodyA.node?.name == "durian" {
			if durian.state == DurianState.boost {
				let b = contact.bodyB.node as! Bug
				b.receiveDamage(1)
			} else {
				sunshineBar.decrease(by: 30)
				boostBar.decrease(by: 50)
			}
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
		let touchedNode = atPoint(pos)
		if isPaused  { return }
		if touchedNode.name == "boostButton" {
			if durian.state != DurianState.boost && boostBar.isMoreThanOrEqualTo(100) {
				durian.state = DurianState.boost
				boostStartTime = self.lastUpdateTime
				boostBar.setEmpty()
				durian.run()
			}
		} else {
			if durian.state == DurianState.boost {
				// TODO: attack animation
				durian.attack()
			}
		}
    }
    
//    // Not needed
//    func touchMoved(toPoint pos : CGPoint) {
//    }
    
	// Pause and Jump handled at touchUp
    func touchUp(atPoint pos : CGPoint) {
		let touchedNode = atPoint(pos)
		if touchedNode.name == "pauseButton" {
			if isPaused {
				isPaused = false
				pauseButton.texture = SKTexture(imageNamed: "pause")
				justUnpaused = true
			} else {
				isPaused = true
				pauseButton.texture = SKTexture(imageNamed: "resume")
			}
		} else {
			if !isPaused {
				if durian.state == DurianState.normal {
					if durian.inAir != 0 {
						durian.jump()
					} else {
						if waterBar.isMoreThanOrEqualTo(90) {
							durian.jump()
							waterBar.decrease(by: 30)
						}
					}
				}
			}
		}
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
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        var dt = currentTime - self.lastUpdateTime
		
        
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
			platform.create(number: platformLength + Int(arc4random_uniform(20)))
            platform.position = CGPoint(x:CGFloat(frame.width) + CGFloat(platformGap + Int(arc4random_uniform(500))), y:50)
            platform.zPosition = 100
            platformPositionR = platform.position.x + platform.width
			platform.name = "platform"
            self.addChild(platform)
            platforms.append(platform)
        }
        
        for p in platforms{
			p.move(speed: GameScene.platformSpeed)
        }
        
		platformPositionR = platformPositionR - CGFloat(GameScene.platformSpeed)
        
        // PlatformLevel move
        if(platformLevels[0].position.x + platformLevels[0].width < 0){
        // remove platform that out of scene
            platformLevels[0].removeFromParent()
            platformLevels.remove(at: 0)
        }
        
        if (platformLevelPositionR < frame.width){
        // create new platform
            platformLevel = Platform()
            platformLevel.create(number: levelLength + Int(arc4random_uniform(3)))
            platformLevel.position = CGPoint(x:CGFloat(frame.width) + CGFloat(levelGap + Int(arc4random_uniform(500))), y:520)
            platformLevel.zPosition = 100
            platformLevelPositionR = platformLevel.position.x + platformLevel.width
            platformLevel.name = "platformLevel"
            self.addChild(platformLevel)
            platformLevels.append(platformLevel)
        }
        
        for pl in platformLevels{
            pl.move(speed: GameScene.platformSpeed)
        }
        
        platformLevelPositionR = platformLevelPositionR - CGFloat(GameScene.platformSpeed)
		
		if fertilizer.inGame {
			fertilizer.move(speed: GameScene.platformSpeed)
		}
		
		// MARK: --Enemies
		if	!enemies.isEmpty && (enemies[0].position.x < -200 || enemies[0].position.y < -200) {
			enemies[0].selfDestruction()
			enemies.removeFirst()
		}
		for e in enemies {
			e.move()
		}
		
		
		// Do not update status bars the first frame after unpause
		// Otherwise health bar drops by a lot (because its based on dt)
        // Unpaused
		if justUnpaused {
			justUnpaused = false
			dt = 0
		}
		
		gameTime += dt
		if durian.state != DurianState.boost {
			sunshineBar.decrease(by: CGFloat(dt * 3))
			waterBar.decrease(by: CGFloat(dt * 3))
		}
		
		// MARK: --Boost
		if durian.state == DurianState.boost && currentTime - boostStartTime > 5 {
			durian.state = DurianState.normal
			durian.run()
		}
		
		// MARK: --Season Change
		seasonTimer += dt
		
		// MARK: --Health Bar
		if sunshineBar.isEmpty() || waterBar.isEmpty() {
			displayGameOver()
		}
		
		// MARK: --Death On Falling
		if durian.position.y < 0 {
			displayGameOver()
		}
        
		
		// MARK: --Absorbtion Related
		if durian.state == DurianState.absorb {
			if sun.isOpen {
				sunshineBar.increase(by: CGFloat(dt * 20))
			}
			if isRaining {
				waterBar.increase(by: CGFloat(dt * 10))
			}
			for f in factories {
				if abs(f.position.x - durian.position.x) < 300 {
					sunshineBar.decrease(by: CGFloat(dt * 25))
				}
			}
			
		}
		if durian.state == DurianState.boost {
			sunshineBar.increase(by: CGFloat(dt * 20))
			waterBar.increase(by: CGFloat(dt * 20))
		}
		if durian.state == DurianState.boost {
			statusBar.increase(by: CGFloat(dt * 20))
		}
		
		// MARK: --Collectable
		if fertilizer.inGame && (fertilizer.position.x < -100 || fertilizer.position.y < -100) {
			fertilizer.removeFromParent()
			fertilizer.inGame = false
		}
		if	!raindrops.isEmpty && !raindrops[0].inGame {
			raindrops.removeFirst()
		}
	
		// Sun Timer
		if sun.isOpen && currentTime - sunStartTime > 10 {
			sun.close()
		}
		
		// MARK: Random Events Generation
		let epsilon = 0.1
		if abs((Double(gameTime) - Double(Int(gameTime)))) < epsilon {
			let num = arc4random_uniform(100)
			
			switch season {
			case .Spring:
				if 1 < num && num <= 5 {
					spawnFactory()
				}
				break
			case .Summer:
				if num <= 1 {
					spawnFertilizer()
					print("carrot spawned")
				}
				break
			case .Fall:
				if 12 < num && num <= 20 && enemies.count == 0 {
					spawnBugs(Int(arc4random_uniform(2)) + 1)
				}
				break
			case .Winter:
				break
			default:
				break
			}
			
			if 5 < num && num <= 12 && !sun.isOpen {
				sunStart()
			}
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
        
        self.lastUpdateTime = currentTime
    }
	
	// Creates a game over scene
	func displayGameOver() {
		
		let gameOverScene = GameOverScene(size: size)
		gameOverScene.scaleMode = scaleMode
		
		let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
		view?.presentScene(gameOverScene, transition: reveal)
	}
	
	// MARK: --Manage Sun Behavior
	func sunStart () {
		sun.open()
		sunStartTime = lastUpdateTime
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
		factory.run(SKAction.moveTo(x: -200, duration: 10), completion: {
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
	
	func spawnBugs (_ num: Int) {
		for i in 1...num {
			let bug = Bug()
			bug.position = CGPoint(x: self.frame.width + 200 * CGFloat(i), y: 600)
			bug.zPosition = 100
			enemies.append(bug)
			self.addChild(bug)
		}
	}
	
	func nextSeason() {
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
		raindrop.run(SKAction.moveTo(y: -100, duration: 0.5), completion: {
			raindrop.removeFromParent()
			raindrop.inGame = false
		})
		raindrops.append(raindrop)
        self.addChild(raindrop)
      }
}

