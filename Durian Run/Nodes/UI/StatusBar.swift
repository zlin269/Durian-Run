//
//  StatusBar.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/19.
//

import SpriteKit

class StatusBar: SKNode {
	
	// dimensions
	private let width: CGFloat = 600
	private let height: CGFloat = 100
    private let borderThickness: CGFloat = 10
	
	private var coloredBar: SKSpriteNode
    private var coloredBar2: SKSpriteNode
	private var circleBar: SKShapeNode
	private var text: SKLabelNode
	var stacks : Int = 0 {
		didSet {
			text.text = String(stacks)
		}
	}
	private var endPercent : CGFloat = 0 {
		didSet {
			if circleBar.isHidden {
				circleBar.isHidden = false
			}
			if endPercent >= 100 {
				endPercent -= 100
				stacks += 1
			}
			circleBar.path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 30, startAngle: .pi/2, endAngle: endAngle, clockwise: false).cgPath
		}
	}
	private var endAngle : CGFloat {
		return .pi / 2 - .pi * 2 * endPercent / 100
	}
	var hasStacks : Bool = true
	
	init(_ color: UIColor) {
		coloredBar = SKSpriteNode(color: color, size: CGSize(width: width - borderThickness * 2, height: height - borderThickness * 2 - 20))
		circleBar = SKShapeNode()
        coloredBar2 = SKSpriteNode(color: UIColor.purple, size: CGSize(width: width - borderThickness * 2, height: 20))
		text = SKLabelNode(text: "0")
		super.init()
		let background = SKSpriteNode(color: UIColor.gray, size: CGSize(width: width, height: height))
		background.anchorPoint = CGPoint(x: 0, y: 0)
		background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
		background.name = "background"
        background.alpha = 0.5
		coloredBar.anchorPoint = CGPoint(x: 0, y: 0)
        coloredBar.position = CGPoint(x: borderThickness, y: borderThickness + coloredBar2.frame.height)
        coloredBar2.anchorPoint = CGPoint(x: 0, y: 0)
        coloredBar2.position = CGPoint(x: borderThickness, y: borderThickness)
		circleBar.position = CGPoint(x: width + 70, y: 50)
		circleBar.lineWidth = 10
		circleBar.strokeColor = color
		text.position = CGPoint(x: 0, y: 0)
		text.fontColor = UIColor.black
		text.fontName = "Bold"
		text.verticalAlignmentMode = .center
		text.horizontalAlignmentMode = .center
		circleBar.addChild(text)
		self.addChild(background)
		self.addChild(coloredBar)
		self.addChild(circleBar)
        self.addChild(coloredBar2)
		circleBar.isHidden = true
	}
	
	func setFull () {
		coloredBar.size.width = width - 2 * borderThickness
        coloredBar2.size.width = width - 2 * borderThickness
	}
	
	func setEmpty() {
		coloredBar.size.width = 0
        coloredBar2.size.width = 0
	}
	
	func isMoreThanOrEqualTo(_ percent: CGFloat) -> Bool {
		return coloredBar.size.width / (width - 2 * borderThickness) >= percent / 100
	}
    
    func secondaryIsMoreThanOrEqualTo(_ percent: CGFloat) -> Bool {
        return coloredBar2.size.width / (width - 2 * borderThickness) >= percent / 100
    }
	
	func increase (by percent: CGFloat) {
		guard 0 <= percent && percent <= 100 else { return }
		coloredBar.size.width += percent / 100 * (width - 2 * borderThickness)
		if coloredBar.size.width > (width - 2 * borderThickness) {
			if hasStacks {
				let exceed = (coloredBar.size.width - (width - 2 * borderThickness))/(width - 2 * borderThickness) * 100
				endPercent += exceed
			}
			coloredBar.size.width = (width - 2 * borderThickness)
		}
	}
	
	func decrease (by percent: CGFloat) {
		guard 0 <= percent && percent <= 100 else { return }
		coloredBar.size.width -= percent / 100 * (width - 2 * borderThickness)
		if coloredBar.size.width < 0 {
			coloredBar.size.width = 0
		}
	}
    
    func secondaryIncrease (by percent: CGFloat) {
        guard 0 <= percent && percent <= 100 else { return }
        coloredBar2.size.width += percent / 100 * (width - 2 * borderThickness)
        if coloredBar2.size.width > (width - 2 * borderThickness) {
            coloredBar2.size.width = (width - 2 * borderThickness)
        }
    }
    
    func secondaryDecrease (by percent: CGFloat) {
        guard 0 <= percent && percent <= 100 else { return }
        coloredBar2.size.width -= percent / 100 * (width - 2 * borderThickness)
        if coloredBar2.size.width < 0 {
            coloredBar2.size.width = 0
        }
    }
	
	func isEmpty() -> Bool {
		return coloredBar.size.width == 0
	}
    
    func secondaryIsEmpty() -> Bool {
        return coloredBar2.size.width == 0
    }
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
