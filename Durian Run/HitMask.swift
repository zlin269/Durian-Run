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
	static var pollution: UInt32 = 0b0100
}
