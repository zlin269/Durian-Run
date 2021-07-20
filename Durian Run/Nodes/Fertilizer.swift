//
//  Fertilizer.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/20.
//
import SpriteKit

class Fertilizer: Collectable {
	
	init() {
		super.init(imageNamed: "carrot")
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
