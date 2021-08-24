//
//  StatsViewController.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/3.
//

import Foundation
import UIKit
import GameKit

class StatsViewController: UIViewController {
	
	var totalDistance: Int = 0
	var totalCoins: Int = 0
	var numberOfRuns: Int = 0
	var screenTapped: Int = 0
	var distanceLabel: UILabel!
	var coinLabel: UILabel!
	var runLabel: UILabel!
	var tapLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let allSubviews = view.subviews
		for v in allSubviews {
			if let textView = v as? UITextView {
				textView.text = "Best Score: " + String(UserDefaults.int(forKey: .highScore)!) + "\n"
				let season = Season.init(rawValue: (UserDefaults.int(forKey: .mostSeasons)!)%4)?.description
				let year = String((UserDefaults.int(forKey: .mostSeasons)!) / 4 + Calendar.current.component(.year, from: Date()))
				textView.text += "Longest Survival time: The " + season! + " of " + year
			}
		}
		
		
		// Do any additional setup after loading the view.
	}
	
	override var shouldAutorotate: Bool {
		return true
	}
	
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return .landscape
		} else {
			return .landscape
		}
	}

	
	
	
}
