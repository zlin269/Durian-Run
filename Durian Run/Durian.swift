//
//  Durian.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/16.
//

import SpriteKit

enum DurianState: Int {
	case run = 1, normal, absorb, boost
}

class Durian: SKSpriteNode {
	
	var state: DurianState = DurianState.normal {
		didSet {
			run() // every time the state changes, execute run() function to update texture
		}
	}
	var inAir: Bool = false { // this variable is used for texture update
		didSet {
			if inAir {
				var jumpTexture = [SKTexture]()
				if state == DurianState.normal {
					jumpTexture.append(SKTexture(imageNamed: "p1_jump"))
				} else if state == DurianState.absorb {
					jumpTexture.append(SKTexture(imageNamed: "p2_jump"))
				} else {
					jumpTexture.append(SKTexture(imageNamed: "p3_jump"))
				}
				self.run(SKAction.animate(with: jumpTexture, timePerFrame: 1))
			} else {
				self.run()
			}
		}
	}
	
	// gathering assets
	let normalRun = SKTextureAtlas(named: "NormalRun")
	let absorbRun = SKTextureAtlas(named: "AbsorbRun")
	let boostRun = SKTextureAtlas(named: "BoostRun")
	
	var normalRunTexture = [SKTexture]()
	var absorbRunTexture = [SKTexture]()
	var boostRunTexture = [SKTexture]()
	
	init() {
		
		let stand = SKTexture(imageNamed: "stand")
		super.init(texture: stand, color: UIColor.white, size: stand.size())
		
		// physics body attributes
		self.physicsBody = SKPhysicsBody(circleOfRadius: 120)
		self.physicsBody?.affectedByGravity = true
		self.physicsBody?.allowsRotation = false
		self.physicsBody?.isDynamic = true
		self.physicsBody?.categoryBitMask = HitMask.durian
		self.physicsBody?.contactTestBitMask = HitMask.platform
		self.physicsBody?.mass = 1
		self.physicsBody?.restitution = 0
		
		for i in 0..<normalRun.textureNames.count {
			normalRunTexture.append(normalRun.textureNamed("p1_walk0\(i+1)"))
		}
		
		for i in 0..<absorbRun.textureNames.count {
			absorbRunTexture.append(absorbRun.textureNamed("p2_walk0\(i+1)"))
		}
		
		for i in 0..<boostRun.textureNames.count {
			boostRunTexture.append(boostRun.textureNamed("p3_walk0\(i+1)"))
		}
		
	}
	
	func run() {
		self.removeAllActions()
		var runTexture = [SKTexture]()
		if state == DurianState.normal {
			runTexture = normalRunTexture
		} else if state == DurianState.absorb {
			runTexture = absorbRunTexture
		} else if state == DurianState.boost {
			runTexture = boostRunTexture
		}
			
		self.run(SKAction.repeatForever(SKAction.animate(with: runTexture, timePerFrame: 0.05)))
	}
	
	func jump() {
		self.removeAllActions()
		self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1000))
	}
	
	func attack() {
		// TODO: attack animation and effects
		print("attack")
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
