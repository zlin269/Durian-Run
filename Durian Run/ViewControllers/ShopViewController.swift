//
//  ShopViewController.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/4.
//

import UIKit

class ShopViewController: UIViewController, UIScrollViewDelegate {
	
	var arrLabels : [UILabel] = []

	var coins: Int = UserDefaults.int(forKey: .coins) ?? 0
	
	override func viewDidLoad() {
		
		for i in 1...5 {
			let label = UILabel()
			label.backgroundColor = UIColor.yellow
			label.text = "Coming Soon \(i)"
			label.adjustsFontSizeToFitWidth = true
			label.textAlignment = .center
			arrLabels.append(label)
		}
		super.viewDidLoad()
		let allSubviews = view.subviews
		for subview in allSubviews {
			if subview.restorationIdentifier == "CoinsLabel" {
				let sv = subview as! UILabel
				sv.text = "Coins: " + String(coins)
				sv.adjustsFontSizeToFitWidth = true
			}
		}
		
		pageControl.backgroundStyle = .automatic
		pageControl.backgroundColor = UIColor.gray
		// Do any additional setup after loading the view.
	}
	
	override func viewDidLayoutSubviews() {
		self.loadScrollView()
	}
	
	func loadScrollView() {
		let pageCount = arrLabels.count
		scrView.delegate = self
		scrView.backgroundColor = UIColor.cyan
		scrView.alpha = 0.5
		scrView.isPagingEnabled = true
		scrView.showsHorizontalScrollIndicator = true
		scrView.showsVerticalScrollIndicator = false
		
		pageControl.numberOfPages = pageCount
		pageControl.currentPage = 0
		
		for i in (0..<pageCount) {
			
			arrLabels[i].frame = CGRect(x: i * Int(scrView.frame.size.width) , y: 0 , width:
										Int(scrView.frame.size.width) , height: Int(scrView.frame.size.height))
			
			self.scrView.addSubview(arrLabels[i])
		}
		
		let width1 = (Float(arrLabels.count) * Float(scrView.frame.size.width))
		scrView.contentSize = CGSize(width: CGFloat(width1), height: scrView.frame.size.height)
		
		self.view.addSubview(scrView)
		self.pageControl.addTarget(self, action: #selector(self.pageChanged(sender:)), for: UIControl.Event.valueChanged)
		
		self.view.addSubview(pageControl)
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
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
		pageControl.currentPage = Int(pageNumber)
		print(pageNumber)
		
		
	}
	
	@objc func pageChanged(sender:AnyObject)
	{
		let xVal = CGFloat(pageControl.currentPage) * scrView.frame.size.width
		scrView.setContentOffset(CGPoint(x: xVal, y: 0), animated: true)
		
	}
}
