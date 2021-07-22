//
//  Rain.swift
//  Durian Run
//
//  Created by Skellig L on 7/22/21.
//

import Foundation
import SpriteKit

class Rain: Collectable {
    
    init() {
        super.init(imageNamed: "rain_drop")
		
		self.inGame = true
		let texture = SKTexture(imageNamed: "rain_drop")
		self.size = texture.size()
		self.physicsBody = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
