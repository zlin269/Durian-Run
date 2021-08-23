//
//  Sleeper.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/23.
//

import Foundation
import SpriteKit

class Sleeper: Enemy {
    
    init() {
        super.init(imageNamed: "blockerSad", withHealth: 1, withSpeed: GameScene.platformSpeed)
        self.name = "blocker"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
