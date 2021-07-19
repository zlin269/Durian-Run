//
//  StatusBar.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/19.
//

import SpriteKit

class StatusBar: SKNode {
	
	// dimensions
	let width: CGFloat = 600
	let height: CGFloat = 100
	
	var coloredBar: SKSpriteNode
	
	init(_ color: UIColor) {
		coloredBar = SKSpriteNode(color: color, size: CGSize(width: width - 40, height: height - 40))
		super.init()
		let background = SKSpriteNode(color: UIColor.gray, size: CGSize(width: width, height: height))
		background.anchorPoint = CGPoint(x: 0, y: 0)
		background.position = CGPoint(x: 0, y: 0)
		coloredBar.anchorPoint = CGPoint(x: 0, y: 0)
		coloredBar.position = CGPoint(x: 20, y: 20)
		self.addChild(background)
		self.addChild(coloredBar)
	}
	
	func setFull () {
		coloredBar.size.width = width - 40
	}
	
	func increase (by percent: CGFloat) {
		guard 0 < percent && percent < 100 else { return }
		coloredBar.size.width += percent / 100 * (width - 40)
		if coloredBar.size.width > (width - 40) {
			coloredBar.size.width = (width - 40)
		}
	}
	
	func decrease (by percent: CGFloat) {
		guard 0 < percent && percent < 100 else { return }
		coloredBar.size.width -= percent / 100 * (width - 40)
		if coloredBar.size.width < 0 {
			coloredBar.size.width = 0
		}
	}
	
	func isEmpty() -> Bool {
		return coloredBar.size.width == 0
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
