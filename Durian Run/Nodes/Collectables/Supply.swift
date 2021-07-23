//
//  Supply.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/23.
//

import SpriteKit

class Supply: Collectable {
	
	init() {
		super.init(imageNamed: "mushroom_red")
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
