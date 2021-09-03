//
//  StatusBar.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/19.
//

import SpriteKit

class StatusBar: SKNode {
	
	// dimensions
	private let width: CGFloat = 500
	private let height: CGFloat = 70
    private let borderThickness: CGFloat = 10
    
	
    private var background: SKSpriteNode
	private var coloredBar: SKSpriteNode
    private var coloredBar2: SKSpriteNode
    private var healthLabel: SKLabelNode
    private var energyLabel: SKLabelNode
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
        background = SKSpriteNode(color: UIColor.gray, size: CGSize(width: width, height: height))
        coloredBar = SKSpriteNode(color: .healthColor, size: CGSize(width: width - borderThickness * 2, height: height - borderThickness * 2 - 20))
		circleBar = SKShapeNode()
        coloredBar2 = SKSpriteNode(color: .energyColor, size: CGSize(width: width - borderThickness * 2, height: 15))
		text = SKLabelNode(text: "0")
        healthLabel = SKLabelNode()
        energyLabel = SKLabelNode()
		super.init()
        let bg1 = SKSpriteNode(color: UIColor(red: 220.0/255, green: 176.0/255, blue: 195.0/255, alpha: 0.8), size: CGSize(width: width - borderThickness * 2, height: height - borderThickness * 2 - 20))
        bg1.anchorPoint = .zero
        bg1.position = CGPoint(x: borderThickness, y: borderThickness + coloredBar2.frame.height + 5)
        let bg2 = SKSpriteNode(color: UIColor(red: 152.0/255, green: 151.0/255, blue: 215.0/255, alpha: 0.8), size: CGSize(width: width - borderThickness * 2, height: 15))
        bg2.anchorPoint = .zero
        bg2.position = CGPoint(x: borderThickness, y: borderThickness)
        background.anchorPoint = CGPoint(x: 0, y: 0)
		background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
		background.name = "background"
        background.alpha = 0.2
		coloredBar.anchorPoint = CGPoint(x: 0, y: 0)
        coloredBar.position = CGPoint(x: borderThickness, y: borderThickness + coloredBar2.frame.height + 5)
        coloredBar.zPosition = 1
        coloredBar2.anchorPoint = CGPoint(x: 0, y: 0)
        coloredBar2.position = CGPoint(x: borderThickness, y: borderThickness)
        coloredBar2.zPosition = 1
		circleBar.position = CGPoint(x: width + 70, y: 50)
		circleBar.lineWidth = 10
		circleBar.strokeColor = color
		text.position = CGPoint(x: 0, y: 0)
		text.fontColor = UIColor.black
		text.fontName = "Bold"
		text.verticalAlignmentMode = .center
		text.horizontalAlignmentMode = .center
		circleBar.addChild(text)
        self.addChild(bg1)
        self.addChild(bg2)
		self.addChild(background)
		self.addChild(coloredBar)
		self.addChild(circleBar)
        self.addChild(coloredBar2)
		circleBar.isHidden = true
        
        let heart = SKSpriteNode(imageNamed: "heart")
        heart.anchorPoint = .zero
        heart.position = CGPoint(x: 0, y: height + 50)
        heart.xScale = 4
        heart.yScale = 4
        let energy = SKSpriteNode(imageNamed: "energy")
        energy.anchorPoint = .zero
        energy.position = CGPoint(x: width / 2, y: height + 50)
        energy.xScale = 4
        energy.yScale = 4
        healthLabel.fontName = "AvenirNextCondensed-Heavy"
        healthLabel.fontSize = 80
        healthLabel.fontColor = .healthColor
        healthLabel.position = CGPoint(x: width * 3 / 8, y: height + 30)
        energyLabel.fontName = "AvenirNextCondensed-Heavy"
        energyLabel.fontSize = 80
        energyLabel.fontColor = .energyColor
        energyLabel.position = CGPoint(x: width * 7 / 8, y: height + 30)
        self.addChild(heart)
        self.addChild(energy)
        self.addChild(healthLabel)
        self.addChild(energyLabel)
	}
	
	func setFull () {
		coloredBar.size.width = width - 2 * borderThickness
        coloredBar2.size.width = width - 2 * borderThickness
        healthLabel.text = "100"
        energyLabel.text = "100%"
	}
	
	func setEmpty() {
		coloredBar.size.width = 0
        coloredBar2.size.width = 0
        healthLabel.text = "0"
        energyLabel.text = "0%"
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
        if coloredBar.size.width > (width - 2 * borderThickness) * 0.1 {
            background.color = .gray
        }
        if coloredBar.size.width > (width - 2 * borderThickness) {
			if hasStacks {
				let exceed = (coloredBar.size.width - (width - 2 * borderThickness))/(width - 2 * borderThickness) * 100
				endPercent += exceed
			}
			coloredBar.size.width = (width - 2 * borderThickness)
		}
        healthLabel.text = "\(Int(coloredBar.size.width / (width - 2 * borderThickness) * 100))"
	}
	
	func decrease (by percent: CGFloat) {
		guard 0 <= percent && percent <= 100 else { return }
		coloredBar.size.width -= percent / 100 * (width - 2 * borderThickness)
        if coloredBar.size.width < 0.1 * (width - 2 * borderThickness) {
            background.color = .red
        }
		if coloredBar.size.width < 0 {
			coloredBar.size.width = 0
		}
        healthLabel.text = "\(Int(coloredBar.size.width / (width - 2 * borderThickness) * 100))"
	}
    
    func secondaryIncrease (by percent: CGFloat) {
        guard 0 <= percent && percent <= 100 else { return }
        coloredBar2.size.width += percent / 100 * (width - 2 * borderThickness)
        if coloredBar2.size.width > (width - 2 * borderThickness) {
            coloredBar2.size.width = (width - 2 * borderThickness)
        }
        energyLabel.text = "\(Int(coloredBar2.size.width / (width - 2 * borderThickness) * 100))%"
    }
    
    func secondaryDecrease (by percent: CGFloat) {
        guard 0 <= percent && percent <= 100 else { return }
        coloredBar2.size.width -= percent / 100 * (width - 2 * borderThickness)
        if coloredBar2.size.width < 0 {
            coloredBar2.size.width = 0
        }
        energyLabel.text = "\(Int(coloredBar2.size.width / (width - 2 * borderThickness) * 100))%"
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

extension UIColor {
    static let healthColor = UIColor(red: 237.0/255, green: 30.0/255, blue: 121.0/255, alpha: 1)
    static let energyColor = UIColor(red: 88.0/255, green: 86.0/255, blue: 124.0/255, alpha: 1)
}
