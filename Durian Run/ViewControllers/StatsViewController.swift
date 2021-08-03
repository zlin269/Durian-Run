//
//  StatsViewController.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/3.
//

import Foundation
import UIKit

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
			print(1)
			if let textView = v as? UITextView {
				textView.text = "Best Score: " + String(UserDefaults.int(forKey: .highScore) ?? 0)
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
