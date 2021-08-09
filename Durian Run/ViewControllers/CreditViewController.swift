//
//  CreditViewController.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/9.
//

import Foundation
import UIKit
import WebKit

class CreditViewController: UIViewController {
	
	var webview = WKWebView()
	var progBar = UIProgressView()
	
	override func viewDidLoad() {
		
		let allSubviews = view.subviews
		for subview in allSubviews {
			if subview is WKWebView {
				webview = subview as! WKWebView
			}
		}
		super.viewDidLoad()

		//创建网址
		let url = URL(string: "https://www.baidu.com")
		//创建请求
		let request = URLRequest(url: url!)
		//加载请求
		webview.load(request)
		//添加wkwebview
		self.view.addSubview(webview)
		
		progBar = UIProgressView(frame: CGRect(x: 0, y: 0, width: webview.frame.width, height: 30))
		progBar.progress = 0.0
		progBar.tintColor = UIColor.red
		webview.addSubview(progBar)
		
		webview.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
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
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			self.progBar.alpha = 1.0
			progBar.setProgress(Float(webview.estimatedProgress), animated: true)
			//进度条的值最大为1.0
			if(self.webview.estimatedProgress >= 1.0) {
				UIView.animate(withDuration: 0.3, delay: 0.1, options: UIView.AnimationOptions.curveEaseInOut , animations: { () -> Void in
					self.progBar.alpha = 0.0
				}, completion: { (finished:Bool) -> Void in
					self.progBar.progress = 0
				})
			}
		}
	}
	
}

