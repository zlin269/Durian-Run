//
//  Durian.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/16.
//

import SpriteKit


class Platform: SKNode {
	
	var width :CGFloat = 0
    var height : CGFloat = 0
    
    var isCity : Bool = false
	
	private var isInitial : Bool = false
	
	override init() {
		super.init()
		self.physicsBody = SKPhysicsBody()
        
	}
	
	init(initial: Bool) {
		isInitial = initial
		super.init()
		self.physicsBody = SKPhysicsBody()
		create(number: 0)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func create (number: Int) {
        var texture = SKTexture()
        
        switch number {
        case 0:
            texture = SKTexture(imageNamed: "city_long")
            isCity = true
        case 1:
            texture = SKTexture(imageNamed: "grass_long")
        case 2:
            texture = SKTexture(imageNamed: "grass_medium\(arc4random_uniform(2) + 1)")
            
        case 3:
            texture = SKTexture(imageNamed: "grass_short\(arc4random_uniform(2) + 1)")
            
        case 4:
            texture = SKTexture(imageNamed: "city_short")
            isCity = true
        case 5:
            texture = SKTexture(imageNamed: "city_long")
            
            isCity = true
        default:
            break
        }
        let grass_m = SKSpriteNode(texture: texture, size: CGSize(width: texture.size().width * 3, height: texture.size().height * 3))
        grass_m.anchorPoint = CGPoint(x: 0, y: 0)
        width = grass_m.size.width
        height = grass_m.size.height
        self.addChild(grass_m)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: grass_m.size.width, height: grass_m.size.height / 2), center: CGPoint(x: width / 2, y: grass_m.size.height / 4))
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = HitMask.platform
        self.physicsBody?.contactTestBitMask = HitMask.durian
        self.physicsBody?.restitution = 0
        self.physicsBody?.friction = 0
		
	}
	
	func move(speed: CGFloat, _ dt: TimeInterval){
        self.position.x = self.position.x - speed * CGFloat(dt)
    }
}
