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
    
	// Big game elements
	lazy var durian = Durian()
	lazy var platform = Platform()
	
	// buttons
	var boostButton = Button(imageNamed: "boost")
	
	
	override func didMove(to view: SKView) {
		
		// gravity
		self.physicsWorld.contactDelegate = self
		self.physicsWorld.gravity = CGVector(dx: 0, dy: -15)
		
		durian.name = "durian"
		platform.name = "platform"
		
		durian.position = CGPoint(x: 300, y: 400)
		durian.size = CGSize(width: durian.size.width * 3, height: durian.size.height * 3)
		durian.run()
		self.addChild(durian)
		platform.position = CGPoint(x: 0, y: 50)
		platform.create(number: 16)
		self.addChild(platform)
		
		boostButton.name = "boostButton"
		boostButton.position = CGPoint(x: 2300, y: 500)
		self.addChild(boostButton)
    }
    
	func didBegin(_ contact: SKPhysicsContact) {
		if contact.bodyA.node?.name == "platform" || contact.bodyB.node?.name == "durian" {
			durian.inAir = false
			durian.run()
		}

	}
    
    func touchDown(atPoint pos : CGPoint) {
		let touchedNode = atPoint(pos)
		if touchedNode.name == "boostButton" {
			if durian.state != DurianState.boost {
				durian.state = DurianState.boost
				boostStartTime = self.lastUpdateTime
				durian.run()
			}
		} else {
			if durian.state == DurianState.boost {
				// TODO: attack animation
				print("attack")
			} else {
				durian.state = DurianState.absorb
			}
		}
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
		if durian.state != DurianState.boost {
			durian.state = DurianState.normal
			if !durian.inAir {
				durian.jump()
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
        
		if durian.state == DurianState.boost && currentTime - boostStartTime > 5 {
			durian.state = DurianState.normal
			durian.run()
		}
		print(currentTime - boostStartTime)
		
		print(durian.state)
        
        self.lastUpdateTime = currentTime
    }
}
