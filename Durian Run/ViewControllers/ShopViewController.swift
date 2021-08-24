//
//  ShopViewController.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/4.
//

import UIKit

class ShopViewController: UIViewController, UIScrollViewDelegate {
	
	var arrLabels : [UILabel] = []

	var coins: Int = UserDefaults.int(forKey: .coins)!
    var coinLabel: UILabel!
    
    var equipButton: UIButton!
    var purchaseButton: UIButton!
    
    var price: UILabel!
	
	override func viewDidLoad() {
        
        if UserDefaults.array(forKey: .charactersOwned) == nil {
            var arr = Array<Bool>(repeating: false, count: 16)
            arr[0] = true
            UserDefaults.set(value: arr, forKey: .charactersOwned)
        }
        
        var i : Int = 0
        while let player =  PlayerModelInfo(rawValue: i) {
			let label = UILabel()
			label.backgroundColor = UIColor.yellow
            label.text = player.name
			label.adjustsFontSizeToFitWidth = true
			label.textAlignment = .center
			arrLabels.append(label)
            i += 1
		}
		super.viewDidLoad()
		let allSubviews = view.subviews
		for subview in allSubviews {
			if subview.restorationIdentifier == "CoinsLabel" {
				let sv = subview as! UILabel
				sv.text = "Coins: " + String(coins)
				sv.adjustsFontSizeToFitWidth = true
                coinLabel = subview as? UILabel
			}
            if subview.restorationIdentifier == "equipButton" {
                let sv = subview as! UIButton
                equipButton = sv
            }
            if subview.restorationIdentifier == "purchaseButton" {
                let sv = subview as! UIButton
                purchaseButton = sv
            }
            if subview.restorationIdentifier == "PriceLabel" {
                price = subview as? UILabel
                price.text = "Equipped"
            }
		}
		
		pageControl.backgroundStyle = .automatic
		pageControl.backgroundColor = UIColor.gray
        
        
        self.equipButton.addTarget(self, action: #selector(self.equip(_:)), for: UIControl.Event.touchUpInside)
        self.purchaseButton.addTarget(self, action: #selector(self.purchase(_:)), for: UIControl.Event.touchUpInside)
		// Do any additional setup after loading the view.
        
        self.pageControl.addTarget(self, action: #selector(self.pageChanged(sender:)), for: UIControl.Event.valueChanged)
        
        let width1 = (Float(arrLabels.count) * Float(scrView.frame.size.width))
        scrView.contentSize = CGSize(width: CGFloat(width1), height: scrView.frame.size.height)
        pageControl.numberOfPages = arrLabels.count
        pageControl.currentPage = UserDefaults.int(forKey: .selectedCharacter)!
        
	}
    
    override func viewDidLayoutSubviews() {
        self.loadScrollView()
        scrView.setContentOffset(CGPoint(x: CGFloat(pageControl.currentPage) * scrView.frame.size.width, y: 0), animated: true)
    }
	
	func loadScrollView() {
		let pageCount = arrLabels.count
		scrView.delegate = self
		scrView.backgroundColor = UIColor.cyan
		scrView.alpha = 0.5
		scrView.isPagingEnabled = true
		
		for i in (0..<pageCount) {
			
			arrLabels[i].frame = CGRect(x: i * Int(scrView.frame.size.width) , y: 0 , width:
										Int(scrView.frame.size.width) , height: Int(scrView.frame.size.height))
			
			self.scrView.addSubview(arrLabels[i])
		}
		

        
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
	@IBOutlet weak var scrView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!
    
	
	//MARK: UIScrollViewDelegate
	func scrollViewDidEndDecelerating (_ scrollView: UIScrollView) {
		let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
		pageControl.currentPage = Int(pageNumber)
		print(pageNumber)
		
        if UserDefaults.array(forKey: .charactersOwned)![pageControl.currentPage] as! Bool {
            equipButton.isHidden = false
            purchaseButton.isHidden = true
            price.text = "Owned"
            if UserDefaults.int(forKey: .selectedCharacter) == pageControl.currentPage {
                equipButton.isHidden = true
                price.text = "Equipped"
            }
        } else {
            equipButton.isHidden = true
            purchaseButton.isHidden = false
            price.text = "\(PlayerModelInfo(rawValue: pageControl.currentPage)!.cost)"
        }
	}
	
	@objc func pageChanged(sender:AnyObject)
	{
		let xVal = CGFloat(pageControl.currentPage) * scrView.frame.size.width
		scrView.setContentOffset(CGPoint(x: xVal, y: 0), animated: true)
        print(pageControl.currentPage)
        if UserDefaults.array(forKey: .charactersOwned)![pageControl.currentPage] as! Bool {
            equipButton.isHidden = false
            purchaseButton.isHidden = true
            price.text = "Owned"
            if UserDefaults.int(forKey: .selectedCharacter) == pageControl.currentPage {
                equipButton.isHidden = true
                price.text = "Equipped"
            }
        } else {
            equipButton.isHidden = true
            purchaseButton.isHidden = false
            price.text = "\(PlayerModelInfo(rawValue: pageControl.currentPage)!.cost)"
        }
	}

    @objc func equip(_ sender: UIButton!) {
        UserDefaults.set(value: pageControl.currentPage, forKey: .selectedCharacter)
        equipButton.isHidden = true
        price.text = "Equipped"
    }

    @objc func purchase(_ sender: UIButton!) {
        print("purchasing")
        if UserDefaults.int(forKey: .coins)! >= 1000 {
            print("purchased Success")
            var arr = UserDefaults.array(forKey: .charactersOwned)!
            arr[pageControl.currentPage] = true
            UserDefaults.set(value: arr, forKey: .charactersOwned)
            UserDefaults.set(value: UserDefaults.int(forKey: .coins)! - 1000, forKey: .coins)
            coins -= 1000
            coinLabel.text = "Coins: " + String(coins)
            equipButton.isHidden = false
            purchaseButton.isHidden = true
            price.text = "Owned"
        }
    }
}
