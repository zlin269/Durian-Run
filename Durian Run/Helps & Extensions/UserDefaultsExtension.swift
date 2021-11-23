//
//  UserDefaultsExtension.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/3.
//

import Foundation

extension UserDefaults {
	
	enum AccountKeys: String {
        // user settings
        case username
        case avatar
		case gameVolume
		case musicVolume
        case language
        case control
        // top record
		case highScore
		case mostSeasons
        // lifetime record
        case totalScore
        case totalTime
        case totalCoins
        case enemiesKilled
        case numOfDeath
        case numOfFall
        case numOfKnockout
        case fled
        // shop related
        case coins
        case selectedCharacter
        case charactersOwned
        // Coupon Points
        case cppoint
        
        case hasFirstAccepted // has accepted protocol(not first used)
        case hasSetName // has accepted set username and avatar
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
    
    static func set(value: [Any], forKey key: AccountKeys) {
        let key = key.rawValue
        UserDefaults.standard.set(value, forKey: key)
    }
	
    static func set(value: Bool, forKey key: AccountKeys) {
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
    
    static func array(forKey key: AccountKeys) -> [Any]? {
        let key = key.rawValue
        return UserDefaults.standard.array(forKey: key)
    }
    
    static func bool(forKey key: AccountKeys) -> Bool? {
        let key = key.rawValue
        return UserDefaults.standard.bool(forKey: key)
    }
}

extension String {
    func toLanguageIndex () -> Int {
        if self == "Chinese" {
            return 0
        } else if self == "English" {
            return 1
        } else if self == "Thai" {
            return 2
        } else {
            return 1
        }
    }
    
    func toControlIndex () -> Int {
        if self == "Swipe" {
            return 0
        } else if self == "Joystick" {
            return 1
        } else if self == "Buttons" {
            return 2
        } else {
            return 0
        }
    }
    
}
