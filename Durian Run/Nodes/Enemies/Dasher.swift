//
//  Dasher.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/5.
//
import SpriteKit

class Dasher: Enemy {
	
	init() {
		super.init(imageNamed: "spikeMan_walk1", withHealth: 1, withSpeed: 0)
		self.name = "bug"
		self.xScale = -1
		self.yScale = 1.5
		self.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "spikeMan_walk1"), SKTexture(imageNamed: "spikeMan_walk2")], timePerFrame: 0.05)))
		self.physicsBody?.categoryBitMask = HitMask.dasher
		self.physicsBody?.contactTestBitMask = HitMask.boundary | HitMask.durian
		self.physicsBody?.collisionBitMask = HitMask.platform | HitMask.durian
		self.physicsBody?.mass = 10
		self.physicsBody?.restitution = 0
		dash()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func selfDestruction() {
		self.physicsBody = nil
		self.movementSpeed = GameScene.platformSpeed * 2
		super.selfDestruction()
	}
	
	func dash () {
		let sound = SKAudioNode(fileNamed: "warning.wav")
		sound.autoplayLooped = false
		self.addChild(sound)
		sound.run(SKAction.sequence([SKAction.changeVolume(to: Float(UserDefaults.double(forKey: .gameVolume) ?? 1), duration: 0), SKAction.play(), SKAction.wait(forDuration: 1)]), completion: {
			self.physicsBody?.velocity = CGVector(dx: -GameScene.platformSpeed * 4, dy: 0)
		})
	}
	
}
