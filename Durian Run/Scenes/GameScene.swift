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
	case Spring, Summer, Fall, Winter

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
			}
		}
	}
    
    var chinese: String {
        get {
            switch self {
            case .Spring:
                return "春天"
            case .Summer:
                return "夏天"
            case .Fall:
                return "秋天"
            case .Winter:
                return "冬天"
            }
        }
    }
    
    var thai: String {
        get {
            switch self {
            case .Spring:
                return "ฤดูใบไม้ผลิ"
            case .Summer:
                return "ฤดูร้อน"
            case .Fall:
                return "ฤดูใบไม้ร่วง"
            case .Winter:
                return "ฤดูหนาว"
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
	private var gameTime : TimeInterval = 0
    private var currentRainDropSpawnTime : TimeInterval = 0
    private var rainDropSpawnRate : TimeInterval = 0.1
	private var season : Season = Season.Spring {
		didSet {
			seasonInfo.nextSeason()
			isRaining = false
			switch season {
			case .Spring:
                let text = {()->String in switch UserDefaults.string(forKey: .language) {
                case "Chinese": return "新的一年 "
                case "English": return "New Year "
                case "Thai": return "ปีใหม่ "
                default: return "ปีใหม่ "
                }}() + "+1500"
				scoreChangeIndicate(text, yPos: frame.height - 700)
				score += 1500
				difficulty += 1
			default: // .Winter
				break
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
    var justUnpaused : Bool = false // prevent loss of health during pause
	var isActuallyPaused : Bool = false
    var gameStarted : Bool = false
    
	// Big game elements
	lazy var durian = PlayerModelInfo(rawValue: UserDefaults.int(forKey: .selectedCharacter)!)!.model
	lazy var platform = Platform(initial: true)
    lazy var platformLevel = Platform()
	lazy var healthBar = StatusBar(UIColor.red)
    lazy var spellCD = CoolDownIndicator(.white)
    
	lazy var fertilizer = Fertilizer()
	lazy var supply = Supply()
	lazy var musicNode = SKAudioNode(fileNamed: "electronic.wav")
	lazy var gameSound = SKAudioNode(fileNamed: "coin.wav")
	
    lazy var platforms = [Platform]()
    lazy var platformLevels = [Platform]()
	lazy var fences = [Fence]()
	lazy var enemies = [Enemy]()
	lazy var raindrops = [Rain]()

	// platforms
	static var platformSpeed : CGFloat = 1000
	var platformGap : CGFloat {
		return GameScene.platformSpeed / 4
	}
    var platformPositionR: CGFloat = 0
    
	// buttons
	var pauseButton = Button(imageNamed: "pause")
    var resumeButton = SKSpriteNode(imageNamed: "Resume-1")
    var settingsButton = SKSpriteNode(imageNamed: "setting")
    var quitButton = SKSpriteNode(imageNamed: "quit")
	
    
    // Pause
    var blur : SKSpriteNode!
    var pausebg : SKSpriteNode!
    
	
	// MARK: --Layers in Scene
	// Layers of nodes in the scene are determined by their zPosition
	// In this game we use the following convention:
	// Any background nodes has zPos < 0
	// Any gameplay related non-physics node has 0 <= zPos < 100
	// Any physics node has 100 <= zPos < 200
	// Any UI node has zPos >= 200
	override func didMove(to view: SKView) {
        
        
		GameScene.sharedInstance = self
		
		GameScene.platformSpeed = 800
		
        print("Inside Gameplay Scene")
            createBackground()
		
		musicNode.autoplayLooped = true
		musicNode.run(SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .musicVolume)!), duration: 0))
		self.addChild(musicNode)
		
		gameSound.autoplayLooped = false
		gameSound.run(SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .gameVolume)!), duration: 0))
		self.addChild(gameSound)
		
		let boundary = Boundary()
		boundary.position = CGPoint(x: -500, y: -300)
		self.addChild(boundary)
		
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
		
        let doubleTapRecognizer  = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        self.view?.addGestureRecognizer(doubleTapRecognizer)
        doubleTapRecognizer.numberOfTapsRequired = 2
        
		// MARK: --gravity
		self.physicsWorld.contactDelegate = self
		self.physicsWorld.gravity = CGVector(dx: 0, dy: -50)
		
		// MARK: -- game elements
        
        let buildings = SKSpriteNode(texture: SKTexture(imageNamed: "Shanghai"), size: self.size)
        buildings.zPosition = -100
        buildings.anchorPoint = .zero
        buildings.position = .zero
        self.addChild(buildings)
        
		durian.name = "durian"
		durian.state = .normal
		durian.position = CGPoint(x: 600, y: 450)
		durian.zPosition = 100
		durian.size = CGSize(width: durian.size.width * 3, height: durian.size.height * 3)
		self.addChild(durian)
		
		platform.name = "platform"
		platform.position = CGPoint(x: 0, y: 0)
		platform.zPosition = 50
        platformPositionR = platform.position.x + platform.width
		self.addChild(platform)
        platforms.append(platform)
        
		
		healthBar.name = "health"
		healthBar.position = CGPoint(x: 80, y: 850)
		healthBar.zPosition = 200
		healthBar.setEmpty()
		healthBar.increase(by: 30)
        healthBar.secondaryIncrease(by: 100)
        healthBar.alpha = 0.8
        healthBar.zRotation = .pi / 16
		self.addChild(healthBar)
        
        spellCD.name = "cd"
        spellCD.position = CGPoint(x: 140, y: 750)
        spellCD.zPosition = 200
        spellCD.setFull()
        self.addChild(spellCD)
		
        resumeButton.name = "resume"
        settingsButton.name = "setting"
        quitButton.name = "quit"
        
		pauseButton.name = "pauseButton"
        pauseButton.position = CGPoint(x: self.size.width - pauseButton.size.width - 80, y: 1100)
		pauseButton.zPosition = 200
		pauseButton.anchorPoint = CGPoint(x: 0, y: 1) // anchor point at top left
		self.addChild(pauseButton)
		
		scoreLabel.fontName = "ChalkboardSE-Bold"
		scoreLabel.fontSize = 200
        scoreLabel.fontColor = healthBar.healthColor
		scoreLabel.position = CGPoint(x: frame.width / 2, y: frame.height - 200)
		scoreLabel.zPosition = 200
		self.addChild(scoreLabel)
		
		coinLabel.fontName = "Italic"
		coinLabel.fontSize = 100
		coinLabel.fontColor = UIColor.orange
        coinLabel.position = CGPoint(x: frame.width - 450, y: frame.height - 200)
		coinLabel.zPosition = 200
		self.addChild(coinLabel)
        
        startingAnimation()
        
        
    }
    
    func createBackground() {
        let backgroundTexture = SKTexture(imageNamed: "clouds")
        
        for i in 0 ... 3 {
            let background = SKSpriteNode(texture: backgroundTexture, size: self.size)
            background.zPosition = -200
            
            background.anchorPoint = CGPoint.zero
            
            background.position = CGPoint(x: (self.size.width * CGFloat(i)) - CGFloat(1 * i), y: 0)
            addChild(background)
            
            let moveLeft = SKAction.moveBy(x: -self.size.width, y: 0, duration: 30)
            let moveReset = SKAction.moveBy(x: self.size.width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            background.run(moveForever)
        }
    }
    
    @objc func doubleTapped (sender: UITapGestureRecognizer) {
        if isPaused {
            return
        }
        if durian.state != DurianState.boost && healthBar.secondaryIsMoreThanOrEqualTo(100) {
            durian.state = DurianState.boost
            boostStartTime = self.lastUpdateTime
            durian.run()
            let tempAudioNode = SKAudioNode(fileNamed: "powerup.wav")
            tempAudioNode.autoplayLooped = false
            self.addChild(tempAudioNode)
            tempAudioNode.run(SKAction.sequence([SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .gameVolume)!), duration: 0), SKAction.play(), SKAction.wait(forDuration: 3), SKAction.removeFromParent()]))
        }
    }
	
	
	@objc func swipedUp (sender: UISwipeGestureRecognizer) {
		if !isPaused {
			if durian.inAir != 0 {
				durian.jump()
			}
		}
	}
	
	@objc func swipedDown (sender: UISwipeGestureRecognizer) {
		if !isPaused {
			durian.drop()
		}
	}
    
	@objc func swipedLeft (sender: UISwipeGestureRecognizer) {
        if isPaused {
            return
        }
		if durian.state != DurianState.boost {
			let tempAudioNode = SKAudioNode(fileNamed: "switch.wav")
			tempAudioNode.autoplayLooped = false
			self.addChild(tempAudioNode)
			tempAudioNode.run(SKAction.sequence([SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .gameVolume)!), duration: 0), SKAction.play(), SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
			if durian.state == .normal {
				durian.state = .absorb
			} else {
				durian.state = .normal
			}
		}
	}
    
    @objc func swipedRight (sender: UISwipeGestureRecognizer) {
        if isPaused {
            return
        }
        if spellCD.isEmpty() {
            durian.attack()
            spellCD.setFull()
        }
    }
    
	
	// MARK: --CONTACT DETECTION
	func didBegin(_ contact: SKPhysicsContact) {
		if ((contact.bodyA.node is Platform || contact.bodyA.node is Fence) && contact.bodyB.node is Durian) ||
            ((contact.bodyB.node is Platform || contact.bodyB.node is Fence) && contact.bodyA.node is Durian) {
			durian.inAir += 1
		}
        if contact.bodyB.node?.name == "cone" && contact.bodyA.node is Durian {
            contact.bodyB.node?.run(SKAction.rotate(byAngle: .pi/2, duration: 0.5))
            contact.bodyB.node?.run(SKAction.moveBy(x: 100, y: 100, duration: 0.5), completion: {
                contact.bodyB.node?.removeFromParent()
            })
            durian.run(SKAction.moveBy(x: -50, y: 0, duration: 0.5))
        }
        if (contact.bodyA.node is Durian && contact.bodyB.node is Fertilizer) {
			fertilizer.getCollected()
			score += 100
            let text = {()->String in switch UserDefaults.string(forKey: .language) {
            case "Chinese": return "收集到肥料"
            case "English": return "Fertilizer Collected"
            case "Thai": return "เก็บปุ๋ย"
            default: return "Fertilizer Collected"
            }}() + " +100"
			scoreChangeIndicate(text, yPos: frame.height - 500)
			healthBar.secondaryIncrease(by: 20)
        }
		if (contact.bodyA.node is Durian && contact.bodyB.node is Supply)  {
			supply.getCollected()
			score += 100
            let text = {()->String in switch UserDefaults.string(forKey: .language) {
            case "Chinese": return "收集到补给"
            case "English": return "Supply Collected"
            case "Thai": return "รวบรวมเสบียง"
            default: return "Supply Collected"
            }}() + " +100"
			scoreChangeIndicate(text, yPos: frame.height - 500)
			healthBar.increase(by: 20)
		}

		if contact.bodyA.node is Durian && contact.bodyB.node is Enemy {
			if contact.bodyB.node is Wall {
				return
			}
            if !durian.invincible {
               if healthBar.stacks > 0 {
					healthBar.stacks -= 1
					if let b = contact.bodyB.node as? Dasher {
						b.selfDestruction()
						durian.physicsBody?.isResting = true
					}
				} else {
					healthBar.decrease(by: 10 + (CGFloat(difficulty) * 5))
				}
			}
		}
        
		if contact.bodyA.node is Boundary {
			contact.bodyB.node?.removeFromParent()
		} else if contact.bodyB.node is Boundary {
			contact.bodyA.node?.removeFromParent()
		}
		
		if contact.bodyA.node is Durian && contact.bodyB.node is Coin {
			let c = contact.bodyB.node as! Coin
			c.getCollected()
			let tempAudioNode = SKAudioNode(fileNamed: "coin.wav")
			tempAudioNode.autoplayLooped = false
			self.addChild(tempAudioNode)
			tempAudioNode.run(SKAction.sequence([SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .gameVolume)!), duration: 0), SKAction.play(), SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
			coins += 1
		}
        if contact.bodyB.node?.name == "bullet" {
            if let enemy = contact.bodyA.node as? Enemy {
                healthBar.increase(by: 10)
                enemy.receiveDamage(1)
                score += 500
                let text = {()->String in switch UserDefaults.string(forKey: .language) {
                case "Chinese": return "消灭敌人"
                case "English": return "Enemy Eliminated"
                case "Thai": return "ทำลายศัตรู"
                default: return "Enemy Eliminated"
                }}() + " +500"
                scoreChangeIndicate(text, yPos: frame.height - 500)
                let tempAudioNode = SKAudioNode(fileNamed: "sword-attack.wav")
                tempAudioNode.autoplayLooped = false
                self.addChild(tempAudioNode)
                tempAudioNode.run(SKAction.sequence([SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .gameVolume)!), duration: 0), SKAction.play(), SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
            }
        }
		
	}
	
	func didEnd(_ contact: SKPhysicsContact) {
		if ((contact.bodyA.node is Platform || contact.bodyA.node is Fence) && contact.bodyB.node is Durian) ||
            ((contact.bodyB.node is Platform || contact.bodyB.node is Fence) && contact.bodyA.node is Durian) {
			durian.inAir -= 1
		}
	}
    
	// Boost Mode and Attack handled at touchDown
    func touchDown(atPoint pos : CGPoint) {
        let touchedNode = atPoint(pos)
            if touchedNode.name == "pauseButton" {
                pause()
            } else if touchedNode.name == "quit" {
                displayGameOver()
            } else if touchedNode.name == "setting" {
                
            } else if touchedNode.name == "resume" {
                unpause()
            }
	}
    
//    // Not needed
//    func touchMoved(toPoint pos : CGPoint) {
//    }
    
	// Pause and Jump handled at touchUp
//    func touchUp(atPoint pos : CGPoint) {
//	}
	
    // MARK: --Pause
	func pause() {
		print("Pausing")
		isActuallyPaused = true
		isPaused = true
		justUnpaused = true
        
        blur = SKSpriteNode(texture: SKTexture(imageNamed: "blur"), color: .white, size: frame.size)
        blur.zPosition = 250
        blur.position = CGPoint(x: frame.midX, y: frame.midY)
        blur.xScale = 2
        blur.yScale = 2
        blur.alpha = 0.8
        self.addChild(blur)
        let scale : CGFloat = 2.7
        pausebg = SKSpriteNode(texture: SKTexture(imageNamed: "pausebg"))
        pausebg.anchorPoint = CGPoint(x: 0.5, y: 0)
        pausebg.position = CGPoint(x: frame.midX, y: 0)
        pausebg.zPosition = 260
        pausebg.xScale = scale
        pausebg.yScale = scale
        self.addChild(pausebg)
        resumeButton.position = CGPoint(x: frame.midX, y: frame.midY + 90)
        resumeButton.zPosition = 270
        resumeButton.xScale = scale
        resumeButton.yScale = scale
        self.addChild(resumeButton)
        settingsButton.position = CGPoint(x: frame.midX, y: frame.midY - 130)
        settingsButton.zPosition = 270
        settingsButton.xScale = scale
        settingsButton.yScale = scale
        self.addChild(settingsButton)
        quitButton.position = CGPoint(x: frame.midX, y: frame.midY - 450)
        quitButton.zPosition = 270
        quitButton.xScale = scale
        quitButton.yScale = scale
        self.addChild(quitButton)
        let durianQuestion = SKSpriteNode(imageNamed: "durianquestion")
        durianQuestion.position = CGPoint(x: -220, y: 200)
        durianQuestion.zPosition = 1
        pausebg.addChild(durianQuestion)
        let durianHog = SKSpriteNode(imageNamed: "durianhog")
        durianHog.position = CGPoint(x: 200, y: 100)
        durianHog.zPosition = 1
        pausebg.addChild(durianHog)
	}
	
	func unpause() {
		print("Unpausing")
		isActuallyPaused = false
		isPaused = false
		justUnpaused = true
        
        blur.removeFromParent()
        pausebg.removeFromParent()
        resumeButton.removeFromParent()
        settingsButton.removeFromParent()
        quitButton.removeFromParent()
	}
    
	// ------------ No Need to Modify Any of the Touches ------------
	
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
    
	// ------------ No Need to Modify Any of the Touches ------------
    
    // MARK: --Update
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
        
        gameTime += dt
        
        if gameStarted {
            seasonTimer += dt
            
            GameScene.platformSpeed += CGFloat(dt * 2)
        // Scoring Update
            score += dt * Double(GameScene.platformSpeed) / 15
            
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
                let num = (season == .Spring || season == .Summer) ? Int(arc4random_uniform(5))  + 1 : 5
                platform.create(number: num)
                platform.position = CGPoint(x: platforms.last!.position.x + platforms.last!.width + ((season == .Spring || season == .Summer) ? platformGap + CGFloat(Int(arc4random_uniform(300))) : 0), y: 0)
                platform.zPosition = 50
                platformPositionR = platform.position.x + platform.width
                platform.name = "platform"
                self.addChild(platform)
                platforms.append(platform)
                if season == .Spring || season == .Summer {
                    Coin.spawnCoinsRainbow(CGPoint(x: platform.position.x - platformGap, y: 680), self)
                    if num == 5 {
                        for i in 1...3 {
                            let fence = Fence(type: arc4random_uniform(4))
                            fence.position = CGPoint(x: platform.position.x + CGFloat(i) * platform.width/4, y: platform.position.y + platform.height / 2 + fence.frame.height / 2)
                            fence.zPosition = 100
                            self.addChild(fence)
                            fences.append(fence)
                        }
                    } else if num == 1 {
                        spawnBugs(7)
                    }
                } else {
                    // MARK: --level platform
                    for i in 1...(arc4random_uniform(6)+3) {
                        let fence = Fence(type: 3)
                        fence.yScale = 1.5
                        fence.position = CGPoint(x: platform.position.x + CGFloat(i) * fence.frame.width + 300, y: platform.position.y + platform.height / 2 + fence.frame.height / 2)
                        fence.zPosition = 100
                        self.addChild(fence)
                        fences.append(fence)
                    }
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
            
            for f in fences {
                f.move(speed: GameScene.platformSpeed, dt)
            }
            
            if fertilizer.inGame {
                fertilizer.move(speed: GameScene.platformSpeed, dt)
            }
            
            // MARK: --Enemies
            if	!enemies.isEmpty && (enemies[0].position.x < -200 || enemies[0].position.y < -100) {
                enemies[0].selfDestruction()
                enemies.removeFirst()
            }
            for e in enemies {
                e.move(dt)
            }
            if season == .Fall || season == .Winter {
                if Int(seasonTimer) >= (5 + 10 * seasonInfo.enemiesSpawned) {
                     seasonInfo.enemiesSpawned += 1
                     spawnBugs(Int(arc4random_uniform(season == .Fall ? 4 : 7)))
                 }
            }
            
            if durian.state != DurianState.boost {
                healthBar.decrease(by: CGFloat(dt * difficulty))
            }
            if !spellCD.isEmpty() {
                spellCD.decrease(by: CGFloat(dt)/durian.attackCD * 100)
            }
            
            // MARK: --Boost
            if durian.state == DurianState.boost  {
                healthBar.secondaryDecrease(by: CGFloat(dt) * 10)
                if healthBar.secondaryIsEmpty() {
                    durian.state = .normal
                    durian.run()
                }
            }
            
            
            // MARK: --Health Bar
            if healthBar.isEmpty()  {
                displayGameOver()
            }
            
            // MARK: --Death On Falling
            if durian.position.y < 0 || self.childNode(withName: "durian") == nil {
                displayGameOver()
            }
            
            // MARK: --Position Adjustment
            if durian.position.x < 0 {
                self.displayGameOver()
            } else if durian.position.x < 595 {
                durian.run(SKAction.moveBy(x: 1, y: 0, duration: dt))
            } else if durian.position.x > 605 {
                durian.run(SKAction.moveBy(x: -5, y: 0, duration: dt))
            }
            
            
            // MARK: --Absorbtion Related
            if durian.state == DurianState.absorb {
                if isRaining {
                    healthBar.increase(by: CGFloat(dt * 5))
                }
                for p in platforms {
                    if durian.position.x - p.position.x > 0 && durian.position.x - p.position.x < p.width  {
                        if p.isCity {
                            healthBar.decrease(by: CGFloat(dt * 15))
                        } else {
                            healthBar.increase(by: CGFloat(dt * 10))
                        }
                    }
                }
                if isStorming {
                    healthBar.decrease(by: CGFloat(dt * 10))
                }
            }
            if durian.state == DurianState.boost {
                healthBar.increase(by: CGFloat(dt * 30))
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
                if num <= 2 {
                    spawnFertilizer()
                }
                switch season {
                case .Spring, .Summer:
                    if 1 < num && num <= 10 {
                        // spawnFactory()
                    }
                    break
    //			case .Fall, .Winter:
    //				if 1 < num && num <= 20 && enemies.count == 0 {
    //                    spawnBugs(Int(arc4random_uniform(4) + ((season == .Winter) ? arc4random_uniform(4) : 0)))
    //				}
    //				break
                default: break
                }
                
            }
            
            // MARK: --Seasonal Events
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
            if !isStorming && seasonTimer > seasonInfo.stormTime! && seasonTimer < seasonInfo.stormTime! + seasonInfo.stormDuration! {
                startStorm()
            }
            if seasonTimer > seasonInfo.supplySpawnTime[0] && seasonInfo.suppliesSpawned == 0 {
                spawnSupply()
            }
            if seasonTimer > seasonInfo.supplySpawnTime[1] && seasonInfo.suppliesSpawned == 1 {
                spawnSupply()
            }
            
            if isRaining {
                // Update the spawn timer
                currentRainDropSpawnTime += dt

                if currentRainDropSpawnTime > rainDropSpawnRate {
                  currentRainDropSpawnTime = 0
                  spawnRaindrop()
                }
            }
        }

		// MARK: --DEBUG INFO
		print("game time:", gameTime)
//		print("durian state:", durian.state)
//		print("in air:", durian.inAir)
		print("Season Timer: ", seasonTimer)
		
		print("Speed: ", GameScene.platformSpeed)

        
        self.lastUpdateTime = currentTime
    }
    
    // initial animation
    func startingAnimation () {
        let truck = SKSpriteNode(imageNamed: "truck")
        platforms.first!.addChild(truck)
        truck.anchorPoint = .zero
        truck.zPosition = 100
        truck.position = CGPoint(x: 100, y: platforms.first!.height / 2)
        truck.xScale = 2
        truck.yScale = 2
        truck.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: truck.size.width * 0.5, height: truck.size.height / 3), center: CGPoint(x: truck.frame.maxX * 0.6, y: truck.frame.maxY/6))
        truck.physicsBody?.isDynamic = false
        durian.run(SKAction.wait(forDuration: 1), completion: {
            self.durian.physicsBody?.applyImpulse(CGVector(dx: 700, dy: 1000))
        })
        durian.run(SKAction.wait(forDuration: 2), completion: {
            self.durian.physicsBody?.isResting = true
            self.gameStarted = true
        })
    }
	
	// Creates a game over scene
	func displayGameOver() {
		
		musicNode.run(SKAction.stop())
		
		let gameOverScene = GameOverScene(size: size, score: score, seasons: seasonsPassed, coins: coins)
		gameOverScene.scaleMode = scaleMode
		
		let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
		view?.presentScene(gameOverScene, transition: reveal)
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
	
    
    // MARK: --ENEMIES
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
		case 4:
			let waver = Waver()
			waver.position = CGPoint(x: self.frame.width + 200 + CGFloat(arc4random_uniform(500)), y: 600)
			waver.zPosition = 100
			enemies.append(waver)
			self.addChild(waver)
		case 5:
			let dasher = Dasher()
			dasher.position = CGPoint(x: self.frame.width + 200, y: 300)
			dasher.zPosition = 100
			enemies.append(dasher)
			self.addChild(dasher)
		case 6:
			let wall = Wall()
			wall.position = CGPoint(x: self.frame.width + 200, y: 600)
			wall.zPosition = 100
			enemies.append(wall)
			self.addChild(wall)
		default:
            let c = arc4random_uniform(3) + 1
            for i in 1...c {
                let blocker = Sleeper()
                blocker.position = CGPoint(x: platforms.last!.position.x + platforms.last!.width * CGFloat(Double(i) - 0.2) / CGFloat(3), y: 600)
                blocker.zPosition = 100
                enemies.append(blocker)
                self.addChild(blocker)
            }
		}
			
	}
	
	func nextSeason() {
		score += 800
        let text = {()->String in switch UserDefaults.string(forKey: .language) {
        case "Chinese": return "季节更替"
        case "English": return "Season Changed"
        case "Thai": return "ฤดูกาลเปลี่ยน"
        default: return "ฤดูกาลเปลี่ยน"
        }}() + " +800"
		scoreChangeIndicate(text, yPos: frame.height - 500)
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
    
    
    // MARK: --Weather Effects
    func spawnRaindrop() {
		
		let raindrop = Rain()
		raindrop.name = "raindrop"
        raindrop.zPosition = 150
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
		if season == .Summer {
				isRaining = true
		}
		let thunder = SKAudioNode(fileNamed: "thunder.wav")
		thunder.autoplayLooped = false
		thunder.run(SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .musicVolume)!), duration: 0))
		let flash = SKSpriteNode(color: UIColor.black, size: self.frame.size)
		flash.addChild(thunder)
		thunder.run(SKAction.play())
		flash.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
		flash.zPosition = 300
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
