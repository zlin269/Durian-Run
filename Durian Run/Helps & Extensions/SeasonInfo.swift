//
//  SeasonInfo.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/26.
//

import Foundation

class SeasonInfo {
	
	var season : Season
	
	var supplySpawnTime = [TimeInterval]()
	var suppliesSpawned: Int = 0
	
	var sunSetTime: TimeInterval?
	var sunSetDuration: TimeInterval?
	
	var rainStartTime = [TimeInterval]()
	var rainDuration: TimeInterval?
	
	var stormTime: TimeInterval?
	var stormDuration: TimeInterval?
	
	var enemiesSpawned: Int = 0
	
	
	init (_ season0: Season = .Winter) {
		season = season0
		nextSeason()
	}
	
	func nextSeason() {
		if season == .Spring {
			season = .Summer
		} else if season == .Summer {
			season = .Fall
		} else if season == .Fall {
			season = .Winter
		} else if season == .Winter {
			season = .Spring
		}
        enemiesSpawned = 0
		switch season {
		case .Spring:
			sunSetTime = TimeInterval(arc4random_uniform(15) + 10)
			sunSetDuration = 15
			rainStartTime = [TimeInterval(arc4random_uniform(8)), TimeInterval(arc4random_uniform(12)) + 20]
			rainDuration = 8
            supplySpawnTime = [.infinity, .infinity]
            stormTime = .infinity
			break
		case .Summer:
			sunSetTime = TimeInterval(arc4random_uniform(25) + 10)
			sunSetDuration = 5
            rainStartTime = [TimeInterval(arc4random_uniform(30)), .infinity]
			rainDuration = 8
			stormTime = TimeInterval(arc4random_uniform(20) + 10)
			stormDuration = 10
            supplySpawnTime = [.infinity, .infinity]
			break
		case .Fall:
			sunSetTime = TimeInterval(arc4random_uniform(25) + 10)
			sunSetTime = 15
			suppliesSpawned = 0
            rainStartTime = [.infinity, .infinity]
			supplySpawnTime = [TimeInterval(arc4random_uniform(20)), TimeInterval(arc4random_uniform(20) + 20)]
            stormTime = .infinity
			break
		case .Winter:
            sunSetTime = 0
            sunSetDuration = .infinity
            rainStartTime = [.infinity, .infinity]
			suppliesSpawned = 0
            supplySpawnTime = [TimeInterval(arc4random_uniform(20)), TimeInterval(arc4random_uniform(20) + 20)]
			stormTime = TimeInterval(arc4random_uniform(20) + 10)
			stormDuration = 10
			break
        }
	}
}
