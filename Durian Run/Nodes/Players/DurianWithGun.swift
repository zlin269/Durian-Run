//
//  DurianWithGun.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/9.
//

import SpriteKit

class DurianWithGun: Durian {
    
    override func attack() {
        print("Time Walk")
        self.run(SKAction.move(by: CGVector(dx: 400, dy: 0), duration: 0.2))
    }
    
}
