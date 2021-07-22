//
//  Extension_1.swift
//  Durian Run
//
//  Created by Lawrence on 7/21/21.
//

import Foundation
import CoreGraphics
import SpriteKit

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}
