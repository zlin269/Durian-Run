//
//  UserDefaultsExtension.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/3.
//

import Foundation

extension UserDefaults {
	
	enum AccountKeys: String {
		case gameVolume
		case musicVolume
		case coins
		case highScore
		case mostSeasons
	}
	
	static func set(value: String, forKey key: AccountKeys) {
		let key = key.rawValue
		UserDefaults.standard.set(value, forKey: key)
	}
	
	static func set(value: Int, forKey key: AccountKeys) {
		let key = key.rawValue
		UserDefaults.standard.set(value, forKey: key)
	}
	
	static func set(value: Double, forKey key: AccountKeys) {
		let key = key.rawValue
		UserDefaults.standard.set(value, forKey: key)
	}
	
	static func string(forKey key: AccountKeys) -> String? {
		let key = key.rawValue
		return UserDefaults.standard.string(forKey: key)
	}
	
	static func int(forKey key: AccountKeys) -> Int? {
		let key = key.rawValue
		return UserDefaults.standard.integer(forKey: key)
	}
	
	static func double(forKey key: AccountKeys) -> Double? {
		let key = key.rawValue
		return UserDefaults.standard.double(forKey: key)
	}
}
