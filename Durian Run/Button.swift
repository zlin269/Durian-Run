//
//  Durian.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/16.
//

import SpriteKit

class Button: SKSpriteNode {
	
	init(imageNamed image: String) {
		let texture = SKTexture(imageNamed: image)
		super.init(texture: texture, color: UIColor.white, size: CGSize(width: 300, height: 300))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
