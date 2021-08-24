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
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: grass_m.size.width, height: (UIImage(named: "city_long")?.size.height)! * 3 / 2), center: CGPoint(x: width / 2, y: grass_m.size.height / 4))
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = HitMask.platform
        self.physicsBody?.contactTestBitMask = HitMask.durian
        self.physicsBody?.restitution = 0
        self.physicsBody?.friction = 0
		
        switch number {
        case 0:
            let truck = SKSpriteNode(imageNamed: "truck")
            self.addChild(truck)
            truck.anchorPoint = .zero
            truck.zPosition = 1
            truck.position = CGPoint(x: 300, y: grass_m.frame.height / 2)
            truck.xScale = 2
            truck.yScale = 2
            let lamp = SKSpriteNode(imageNamed: "street_lamp")
            lamp.anchorPoint = .zero
            lamp.zPosition = 1
            lamp.xScale = 3
            lamp.yScale = 3
            lamp.position = CGPoint(x: 1800, y: grass_m.frame.height / 2 + 25)
            self.addChild(lamp)
        case 1:
            var trees = [SKSpriteNode(imageNamed: "tree_s"), SKSpriteNode(imageNamed: "tree_m"), SKSpriteNode(imageNamed: "tree_l")]
            trees.shuffle()
            var i : CGFloat = 0
            for tree in trees {
                tree.anchorPoint = CGPoint(x: 0.5, y: 0)
                tree.zPosition = 1
                tree.xScale = 3
                tree.yScale = 3
                tree.position = CGPoint(x: grass_m.frame.width / 3 * i + CGFloat(Float(arc4random()) / Float(UINT32_MAX) / 8) * grass_m.frame.width  + 100, y: grass_m.frame.height * 3/4 - 30)
                i += 1
                self.addChild(tree)
            }
        case 2, 3:
            var large = false
            var imageName : String
            switch arc4random_uniform(3) {
            case 0:
                imageName = "tree_s"
            case 1:
                imageName = "tree_m"
            default:
                imageName = "tree_l"
                large = true
            }
            let tree = SKSpriteNode(imageNamed: imageName)
            tree.anchorPoint = CGPoint(x: 0.5, y: 0)
            tree.zPosition = 1
            tree.xScale = 3
            tree.yScale = 3
            tree.position = CGPoint(x: grass_m.frame.midX + CGFloat((large ? 0 : Int(arc4random_uniform(200)) - 100)), y: grass_m.frame.height * 3/4 - 30)
            self.addChild(tree)
        case 4:
            let lamp = SKSpriteNode(imageNamed: "street_lamp")
            lamp.anchorPoint = .zero
            lamp.zPosition = 1
            lamp.xScale = 3
            lamp.yScale = 3
            lamp.position = CGPoint(x: CGFloat(Float(arc4random()) / Float(UINT32_MAX) / 2) * grass_m.frame.width + 50, y: grass_m.frame.height / 2 + 25)
            self.addChild(lamp)
        case 5:
            for i in 0...2 {
                let lamp = SKSpriteNode(imageNamed: "street_lamp")
                lamp.anchorPoint = .zero
                lamp.zPosition = 1
                lamp.xScale = 3
                lamp.yScale = 3
                lamp.position = CGPoint(x: CGFloat(i) * grass_m.frame.width / 3 + 300, y: grass_m.frame.height / 2 + 25)
                self.addChild(lamp)
            }
        default:
            break
        }
	}
	
	func move(speed: CGFloat, _ dt: TimeInterval){
        self.position.x = self.position.x - speed * CGFloat(dt)
    }
}
