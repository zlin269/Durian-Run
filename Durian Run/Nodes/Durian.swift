//
//  Durian.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/16.
//

import SpriteKit
import AVFoundation

enum DurianState: Int {
	case run = 1, normal, absorb, boost
}

class Durian: SKSpriteNode {
	
	var sound = SKAudioNode(fileNamed: "jump.mp3")
	var runSound = SKAudioNode(fileNamed: "run.mp3")
	
	var state: DurianState = DurianState.normal {
		didSet {
			run() // every time the state changes, execute run() function to update texture
		}
	}
	// this variable is used for texture update and jump determination
	// UInt is used because Bool is not suffcient. It is possible to be in
	// contact with multiple platforms and we need to make sure ending contact
	// with one of the platform does not make the character inAir
	var inAir: UInt = 0 {
		didSet {
			if inAir == 0 {
				var jumpTexture = [SKTexture]()
				if state == DurianState.normal {
					jumpTexture.append(SKTexture(imageNamed: "p1_jump"))
				} else if state == DurianState.absorb {
					jumpTexture.append(SKTexture(imageNamed: "p2_jump"))
				} else {
					jumpTexture.append(SKTexture(imageNamed: "p3_jump"))
				}
				self.run(SKAction.animate(with: jumpTexture, timePerFrame: 0.1))
				runSound.run(SKAction.stop())
			} else {
				self.run()
				runSound.run(SKAction.play())
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
		
		runSound.autoplayLooped = true
		self.addChild(runSound)
		sound.autoplayLooped = false
		self.addChild(sound)
		
		// physics body attributes
		self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 260), center: CGPoint(x: 0, y: 0))
		self.physicsBody?.affectedByGravity = true
		self.physicsBody?.allowsRotation = false
		self.physicsBody?.isDynamic = true
		self.physicsBody?.categoryBitMask = HitMask.durian
		self.physicsBody?.contactTestBitMask = HitMask.collectable
		self.physicsBody?.collisionBitMask = HitMask.platform
        self.physicsBody?.categoryBitMask = HitMask.durian
		self.physicsBody?.mass = 1
		self.physicsBody?.restitution = 0
		self.physicsBody?.friction = 0
		
		for i in 0..<normalRun.textureNames.count {
			normalRunTexture.append(normalRun.textureNamed("p1_walk0\(i+1)"))
		}
		
		for i in 0..<absorbRun.textureNames.count {
			absorbRunTexture.append(absorbRun.textureNamed("p2_walk0\(i+1)"))
		}
		
		for i in 0..<boostRun.textureNames.count {
			boostRunTexture.append(boostRun.textureNamed("p3_walk0\(i+1)"))
		}
		
		self.yScale = 0.8
		
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
		if inAir == 0 {
			var jumpTexture = [SKTexture]()
			if state == DurianState.normal {
				jumpTexture.append(SKTexture(imageNamed: "p1_jump"))
			} else if state == DurianState.absorb {
				jumpTexture.append(SKTexture(imageNamed: "p2_jump"))
			} else {
				jumpTexture.append(SKTexture(imageNamed: "p3_jump"))
			}
			self.run(SKAction.animate(with: jumpTexture, timePerFrame: 0.1))
		} else {
			self.run(SKAction.repeatForever(SKAction.animate(with: runTexture, timePerFrame: 0.05)))
		}
	}
	
	func jump() {
		self.removeAllActions()
		if inAir == 0 {
			self.physicsBody?.isResting = true
		}
		self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 1500))
		sound.run(SKAction.play())
	}
	
	func attack() {
		// TODO: attack animation and effects
		print("attack")
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
