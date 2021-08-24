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
	static var boundary : UInt32 = 0b00010000
	static var dasher : UInt32 = 0b00100000
    static var bullet : UInt32 = 0b01000000
}
