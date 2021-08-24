//
//  CoolDownIndicator.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/18.
//

import SpriteKit

class CoolDownIndicator: SKNode {
    
    // dimensions
    private let height: CGFloat = 100
    private var circleBar: SKShapeNode
    private var endPercent : CGFloat = 0 {
        didSet {
            if endPercent >= 100 {
                endPercent = 100
            } else if endPercent <= 0 {
                endPercent = 0
            }
            circleBar.path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 30, startAngle: .pi/2, endAngle: endAngle, clockwise: false).cgPath
        }
    }
    private var endAngle : CGFloat {
        return .pi / 2 - .pi * 2 * endPercent / 100
    }
    var hasStacks : Bool = true
    
    init(_ color: UIColor) {
        circleBar = SKShapeNode()
        super.init()
        let background = SKShapeNode(circleOfRadius: 60)
        background.fillColor = .orange
        circleBar.lineWidth = 50
        circleBar.strokeColor = .gray
        circleBar.alpha = 0.5
        self.addChild(background)
        self.addChild(circleBar)
    }
    
    func setFull () {
        endPercent = 100
    }
    
    func setEmpty() {
        endPercent = 0
    }
    
    func increase (by percent: CGFloat) {
        guard 0 < percent && percent < 100 else { return }
        endPercent += percent
    }
    
    func decrease (by percent: CGFloat) {
        guard 0 < percent && percent < 100 else { return }
        endPercent -= percent
    }
    
    func isEmpty() -> Bool {
        return endPercent == 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
