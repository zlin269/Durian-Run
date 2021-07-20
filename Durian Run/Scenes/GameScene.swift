//
//  GameScene.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/16.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
	// time var
    private var lastUpdateTime : TimeInterval = 0
	private var boostStartTime : TimeInterval = 0 // keep track of when boost will end
	private var sunStartTime : TimeInterval = 0
	private var justUnpaused : Bool = false // prevent loss of health during pause
	private var gameTime : TimeInterval = 0
    
	// Big game elements
	lazy var durian = Durian()
	lazy var platform = Platform()
	lazy var statusBar = StatusBar(UIColor.red)
	lazy var sun = Sun()
	
    var platforms = [Platform]()

	// platforms
    var platformSpeed = 6
    var platformLength = 2
    var platformGap = 150
    var platformPositionR: CGFloat = 0
    
	// buttons
	var boostButton = Button(imageNamed: "boost")
	var pauseButton = Button(imageNamed: "pause")
	
	
	override func didMove(to view: SKView) {
		
		// long press gesture recognizer
		let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHappened))
		self.view?.addGestureRecognizer(recognizer)
		
		// MARK: --gravity
		self.physicsWorld.contactDelegate = self
		self.physicsWorld.gravity = CGVector(dx: 0, dy: -15)
		
		// game elements
		
		durian.name = "durian"
		durian.position = CGPoint(x: 300, y: 500)
		durian.size = CGSize(width: durian.size.width * 3, height: durian.size.height * 3)
		self.addChild(durian)
		
		platform.name = "platform"
		platform.position = CGPoint(x: 0, y: 50)
		platform.create(number: 16)
        platformPositionR = platform.position.x + platform.width
		self.addChild(platform)
        platforms.append(platform)
		
		statusBar.name = "health"
		statusBar.position = CGPoint(x: 1800, y: 1000)
		self.addChild(statusBar)
		
		sun.name = "sun"
		sun.position = CGPoint(x: 1300, y: 800)
		self.addChild(sun)
		
		boostButton.name = "boostButton"
		boostButton.position = CGPoint(x: 2350, y: 500)
		boostButton.anchorPoint = CGPoint(x: 1, y: 1) // anchor point at bottom top
		self.addChild(boostButton)
		
		pauseButton.name = "pauseButton"
		pauseButton.position = CGPoint(x: 80, y: 1100)
		pauseButton.size = CGSize(width: 200, height: 200)
		pauseButton.anchorPoint = CGPoint(x: 0, y: 1) // anchor point at top left
		self.addChild(pauseButton)
		
    }
	
	// Long press event, handles absorb action
	@objc func longPressHappened (sender: UILongPressGestureRecognizer) {
		if durian.state != DurianState.boost {
			if sender.state == .began { durian.state = DurianState.absorb }
			if sender.state == .ended { durian.state = DurianState.normal }
		}
	}
    
	func didBegin(_ contact: SKPhysicsContact) {
		if contact.bodyA.node?.name == "platform" || contact.bodyB.node?.name == "durian" {
			durian.inAir = false
		}

	}
	
	func didEnd(_ contact: SKPhysicsContact) {
		if contact.bodyA.node?.name == "platform" || contact.bodyB.node?.name == "durian" {
			durian.inAir = true
		}
	}
    
	// Boost Mode and Attack handled at touchDown
    func touchDown(atPoint pos : CGPoint) {
		let touchedNode = atPoint(pos)
		if isPaused  { return }
		if touchedNode.name == "boostButton" {
			if durian.state != DurianState.boost {
				durian.state = DurianState.boost
				boostStartTime = self.lastUpdateTime
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
					if !durian.inAir {
						durian.jump()
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
        let dt = currentTime - self.lastUpdateTime
        
        // Platform move
        if(platforms[0].position.x + platforms[0].width < 0){
        // remove platform that out of scene
			platforms[0].removeFromParent()
            platforms.remove(at: 0)
        }
        
        if (platformPositionR < frame.width){
        // create new platform
            platform = Platform()
            platform.create(number: platformLength)
            platform.position = CGPoint(x:Int(frame.width) + platformGap, y:50)
            platformPositionR = platform.position.x + platform.width
            self.addChild(platform)
            platforms.append(platform)
        }
        
        for p in platforms{
            p.move(speed: platformSpeed)
        }
        
        platformPositionR = platformPositionR - CGFloat(platformSpeed)
		
		// Do not update status bars the first frame after unpause
		// Otherwise health bar drops by a lot (because its based on dt)
        // Unpaused
		if justUnpaused {
			justUnpaused = false
		} else {
			gameTime += dt
			if durian.state != DurianState.boost {
				statusBar.decrease(by: CGFloat(dt * 5))
			}
		}
		
		// MARK: --Health Bar
		if statusBar.isEmpty() {
			displayGameOver()
		}
		
		// MARK: --Death On Falling
		if durian.position.y < 0 {
			displayGameOver()
		}
        
		// MARK: --Boost
		if durian.state == DurianState.boost && currentTime - boostStartTime > 5 {
			durian.state = DurianState.normal
			durian.run()
		}
		
		// MARK: --Absorb
		if sun.isOpen {
			if durian.state == DurianState.absorb {
				statusBar.increase(by: CGFloat(dt * 20))
			}
			if currentTime - sunStartTime > 10 {
				sun.close()
			}
		}
		let epsilon = 0.1
		if abs((Double(gameTime) - Double(Int(gameTime)))) < epsilon && !sun.isOpen {
			let num = arc4random_uniform(30)
			if num == 0 {
				sunStart()
			}
		}
		print(abs((Double(gameTime) - Double(Int(gameTime)))))

		// MARK: --DEBUG INFO
		print(gameTime)
		print(durian.state)
		print(sun.isOpen)
        
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
	
}

