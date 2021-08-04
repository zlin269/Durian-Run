//
//  ShopViewController.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/4.
//

import UIKit

class ShopViewController: UIViewController {

	var coins: Int = UserDefaults.int(forKey: .coins) ?? 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let allSubviews = view.subviews
		for subview in allSubviews {
			if subview.restorationIdentifier == "CoinsLabel" {
				let sv = subview as! UILabel
				sv.text = "Coins: " + String(coins)
				sv.adjustsFontSizeToFitWidth = true
			}
		}
		
		
		
		// Do any additional setup after loading the view.
	}
	
	override var shouldAutorotate: Bool {
		return true
	}
	
	override var prefersStatusBarHidden: Bool {
		return false
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
