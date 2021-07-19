//
//  StatusBar.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/19.
//

import SpriteKit


class StatusBar: SKSpriteNode {
	
	
	
	init() {
		
		super.init(texture: SKTexture(), color: UIColor.white, size: CGSize(width: 700, height: 100))
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
