//
//  StatsViewController.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/3.
//

import Foundation
import UIKit
import GameKit

class CouponViewController: UIViewController, UIScrollViewDelegate {
	
    let couponPrice = 10
    
    @IBOutlet weak var scrView: UIScrollView!
    var arrLabels : [UITextView] = []
    var totalDistance: Int = 0
	var totalCoins: Int = 0
	var numberOfRuns: Int = 0
	var screenTapped: Int = 0
	var distanceLabel: UILabel!
	var coinLabel: UILabel!
	var runLabel: UILabel!
	var tapLabel: UILabel!
    var avaiableCoupons: [Coupon]!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        arrLabels = []
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("coupons")

        do {
            let data = try Data(contentsOf: path)
            if let coupons = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Coupon] {
                avaiableCoupons = coupons
                print("success")
                print(avaiableCoupons.count)
                var i : Int = 0
                for c in coupons {
                    if c.checkDate() {
                        let label = UITextView()
                        label.isEditable = false
                        label.backgroundColor = .yellow
                        label.text = c.couponType + "\n"
                        label.text! += "Remaining Usage: \(c.numberOfUse) \n"
                        label.text! += "Expires On: " + c.getExprirationDate()
                        label.textAlignment = .center
                        label.font = UIFont(name: "ArialMT", size: 30)
                        arrLabels.append(label)
                        i += 1
                    } else {
                        avaiableCoupons.remove(at: i)
                    }
                }
                let newdata = try NSKeyedArchiver.archivedData(withRootObject: avaiableCoupons!, requiringSecureCoding: false)
                try newdata.write(to: path)
            }
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
		
		
		// Do any additional setup after loading the view.
        cppointLabel.text = "\(couponPrice - UserDefaults.int(forKey: .cppoint)!)"
        couponLabel.text = "\(avaiableCoupons.count)"
        
        if UserDefaults.int(forKey: .cppoint)! >= couponPrice {
            redeemCoupon();
        }
	}
    
    func loadScrollView() {
        scrView.delegate = self
        scrView.backgroundColor = UIColor.cyan
        scrView.alpha = 0.5
        scrView.isPagingEnabled = true
        scrView.contentSize = CGSize(width: scrView.frame.width * CGFloat(arrLabels.count), height: scrView.frame.height)
        for v in scrView.subviews {
            v.removeFromSuperview()
        }
        
        for i in (0..<arrLabels.count) {
            
            arrLabels[i].frame = CGRect(x: i * Int(scrView.frame.size.width) , y: 0 , width:
                                        Int(scrView.frame.size.width) , height: Int(scrView.frame.size.height))
            
            self.scrView.addSubview(arrLabels[i])
        }
        if arrLabels.count == 0 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width:
                                                Int(scrView.frame.size.width), height: Int(scrView.frame.size.height)))
            label.text = "No Coupon Available. Go Play Some Games"
            label.textAlignment = .center
            label.font = UIFont(name: "ArialMT", size: 25)
            self.scrView.addSubview(label)
        }
    }
    
    override func viewDidLayoutSubviews() {
        loadScrollView()
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
    
    func redeemCoupon() {
        if UserDefaults.int(forKey: .cppoint)! >= couponPrice {
            UserDefaults.set(value: UserDefaults.int(forKey: .cppoint)! - couponPrice, forKey: .cppoint)
            avaiableCoupons.append(Coupon())
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("coupons")
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: avaiableCoupons!, requiringSecureCoding: false)
                print(avaiableCoupons.count)
                try data.write(to: path)
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
            viewDidLoad()
            loadScrollView()
        } else {
            let alert = UIAlertController(title: "Notice", message: "Not Sufficient CP Points", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func useCoupon(_ sender: UIButton) {
        if avaiableCoupons.count > 0 {
            let alert = UIAlertController(title: "Confirmation", message: "Are You Sure You Want To Use A Coupon?\nUsed Coupon Cannot Be Restored!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: "Yes action"), style: .default, handler: { [self] _ in
                let index = Int(round(scrView.contentOffset.x/scrView.frame.size.width))
                if avaiableCoupons[index].checkDate() {
                avaiableCoupons[index].numberOfUse -= 1
                    if avaiableCoupons[index].numberOfUse == 0 {
                        avaiableCoupons.remove(at: index)
                    }
                } else {
                    let notice = UIAlertController(title: "Notice", message: "The Coupon has Expired!", preferredStyle: .alert)
                    notice.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "No action"), style: .default, handler: nil))
                    avaiableCoupons.remove(at: index)
                    self.present(notice, animated: true, completion: nil)
                }
                let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("coupons")
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: avaiableCoupons!, requiringSecureCoding: false)
                    try data.write(to: path)
                } catch {
                    print("ERROR: \(error.localizedDescription)")
                }
                viewDidLoad()
                loadScrollView()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "No action"), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Notice", message: "Not Sufficient Coupons", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Play", comment: ""), style: .default, handler: {_ in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "game")
                vc.view.frame = (self.view?.frame)!
                vc.view.layoutIfNeeded()
                UIView.transition(with: self.view!, duration: 0.3, options: .transitionCrossDissolve, animations:
                                    {
                                        self.view?.window?.rootViewController = vc
                                    }, completion: { completed in
                                    })
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

