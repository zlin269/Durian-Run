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
	var boostStartTime : TimeInterval = 0
	var justUnpaused : Bool = false
    
	// Big game elements
	lazy var durian = Durian()
	lazy var platform = Platform()
	var statusBar = StatusBar(UIColor.red)
	
	// buttons
	var boostButton = Button(imageNamed: "boost")
	var pauseButton = Button(imageNamed: "pause")
	
	
	override func didMove(to view: SKView) {
		
		// long press gesture recognizer
		let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHappened))
		self.view?.addGestureRecognizer(recognizer)
		
		// gravity
		self.physicsWorld.contactDelegate = self
		self.physicsWorld.gravity = CGVector(dx: 0, dy: -15)
		
		durian.name = "durian"
		durian.position = CGPoint(x: 300, y: 500)
		durian.size = CGSize(width: durian.size.width * 3, height: durian.size.height * 3)
		self.addChild(durian)
		
		platform.name = "platform"
		platform.position = CGPoint(x: 0, y: 50)
		platform.create(number: 16)
		self.addChild(platform)
		
		statusBar.name = "health"
		statusBar.position = CGPoint(x: 1800, y: 1000)
		self.addChild(statusBar)
		
		boostButton.name = "boostButton"
		boostButton.position = CGPoint(x: 2300, y: 500)
		self.addChild(boostButton)
		
		pauseButton.name = "pauseButton"
		pauseButton.position = CGPoint(x: 80, y: 1100)
		pauseButton.size = CGSize(width: 200, height: 200)
		pauseButton.anchorPoint = CGPoint(x: 0, y: 1) // anchor point at top left
		self.addChild(pauseButton)
		
    }
	
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
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
		
		if justUnpaused {
			justUnpaused = false
		} else {
			if durian.state != DurianState.boost {
				statusBar.decrease(by: CGFloat(dt * 10))
			}
		}
		
		if statusBar.isEmpty() {
			displayGameOver()
		}
        
		if durian.state == DurianState.boost && currentTime - boostStartTime > 5 {
			durian.state = DurianState.normal
			durian.run()
		}
		print(currentTime - boostStartTime)
		
		print(durian.state)
        
        self.lastUpdateTime = currentTime
    }
	
	func displayGameOver() {
		
		let gameOverScene = GameOverScene(size: size)
		gameOverScene.scaleMode = scaleMode
		
		let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
		view?.presentScene(gameOverScene, transition: reveal)
	}
	
}

