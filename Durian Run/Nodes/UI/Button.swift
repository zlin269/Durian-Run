//
//  Button.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/19.
//

import SpriteKit

class Button: SKSpriteNode {
	
	// Buttons have default size of 200 by 200
	init(imageNamed image: String) {
		let texture = SKTexture(imageNamed: image)
		super.init(texture: texture, color: UIColor.white, size: CGSize(width: 100, height: 100))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
