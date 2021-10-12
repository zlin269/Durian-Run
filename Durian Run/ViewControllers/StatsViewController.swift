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
		
		// let allSubviews = view.subviews
        /*
		for v in allSubviews {
			if let textView = v as? UITextView {
				textView.text = "Best Score: " + String(UserDefaults.int(forKey: .highScore)!) + "\n"
				let season = Season.init(rawValue: (UserDefaults.int(forKey: .mostSeasons)!)%4)?.description
				let year = String((UserDefaults.int(forKey: .mostSeasons)!) / 4 + Calendar.current.component(.year, from: Date()))
				textView.text += "Longest Survival time: The " + season! + " of " + year
			}
		}
		*/
		
		// Do any additional setup after loading the view.
        cppointLabel.text = "\(UserDefaults.int(forKey: .cppoint)!)"
        couponLabel.text = "\(UserDefaults.int(forKey: .coupon)!)"
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

	
    @IBOutlet weak var cppointLabel: UILabel!
    
    @IBOutlet weak var couponLabel: UILabel!
    
    @IBAction func redeemCoupon(_ sender: UIButton) {
        if UserDefaults.int(forKey: .cppoint)! >= 10 {
            UserDefaults.set(value: UserDefaults.int(forKey: .cppoint)! - 10, forKey: .cppoint)
            UserDefaults.set(value: UserDefaults.int(forKey: .coupon)! + 1, forKey: .coupon)
            viewDidLoad()
        } else {
            let alert = UIAlertController(title: "Notice", message: "Not Sufficient CP Points", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func useCoupon(_ sender: UIButton) {
        if UserDefaults.int(forKey: .coupon)! > 0 {
            let alert = UIAlertController(title: "Confirmation", message: "Are You Sure You Want To Use A Coupon?\nUsed Coupon Cannot Be Restored!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: "Yes action"), style: .default, handler: { _ in
                UserDefaults.set(value: UserDefaults.int(forKey: .coupon)! - 1, forKey: .coupon)
                self.viewDidLoad()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "No action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Notice", message: "Not Sufficient Coupons", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
