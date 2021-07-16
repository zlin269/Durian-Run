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
	
	var state: DurianState = DurianState.normal
	
	let normalRun = SKTextureAtlas(named: "NormalRun")
	let absorbRun = SKTextureAtlas(named: "AbsorbRun")
	let boostRun = SKTextureAtlas(named: "BoostRun")
	
	var normalRunTexture = [SKTexture]()
	var absorbRunTexture = [SKTexture]()
	var boostRunTexture = [SKTexture]()
	
	init() {
		
		
		let stand = SKTexture(imageNamed: "stand")
		super.init(texture: stand, color: UIColor.white, size: stand.size())
		
		self.physicsBody = SKPhysicsBody(circleOfRadius: 120)
		self.physicsBody?.affectedByGravity = true
		self.physicsBody?.allowsRotation = false
		self.physicsBody?.isDynamic = true
		self.physicsBody?.categoryBitMask = HitMask.durian
		self.physicsBody?.contactTestBitMask = HitMask.platform
		self.physicsBody?.mass = 1
		
		for i in 0..<normalRun.textureNames.count {
			normalRunTexture.append(normalRun.textureNamed("p1_walk0\(i+1)"))
		}
		
		for i in 0..<absorbRun.textureNames.count {
			absorbRunTexture.append(normalRun.textureNamed("p2_walk0\(i+1)"))
		}
		
		for i in 0..<boostRun.textureNames.count {
			boostRunTexture.append(normalRun.textureNamed("p3_walk0\(i+1)"))
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
		var jumpTexture = [SKTexture]()
		if state == DurianState.normal {
			jumpTexture.append(SKTexture(imageNamed: "p1_jump"))
		} else if state == DurianState.absorb {
			jumpTexture.append(SKTexture(imageNamed: "p2_jump"))
		} else {
			jumpTexture.append(SKTexture(imageNamed: "p3_jump"))
		}
		
		self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1000))
		
		self.run(SKAction.animate(with: jumpTexture, timePerFrame: 1))
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
