//
//  HitMask.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/16.
//
// Check out this article about Collision and Contacts in SpriteKit:
// https://developer.apple.com/documentation/spritekit/skphysicsbody/about_collisions_and_contacts

import Foundation

class HitMask {
	static var durian: UInt32 = 0b0001
	static var platform: UInt32 = 0b0010
	static var enemy: UInt32 = 0b0100
	static var collectable: UInt32 = 0b1000
    
    static var WorldCategory    : UInt32 = 0x1 << 1
    static var RainDropCategory : UInt32 = 0x1 << 2
    static var FloorCategory    : UInt32 = 0x1 << 3
}
