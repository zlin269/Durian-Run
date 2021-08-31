//
//  MainMenuViewController.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/24.
//

import Foundation
import GameKit

class MainMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        
        let allSubviews = view.subviews
        for v in allSubviews {
            if v.restorationIdentifier == "TouchToStart" {
                if UserDefaults.string(forKey: .language) == "Chinese" {
                    (v as! UILabel).text = "点击屏幕开始"
                } else if UserDefaults.string(forKey: .language) == "Thai" {
                    (v as! UILabel).text = "Touch to Start in Thai"
                } else {
                    (v as! UILabel).text = "Touch To Start"
                }
                // (v as! UILabel).blink()
                self.view.bringSubviewToFront(v)
            }
        }
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
}

extension UILabel {
    func blink() {
        self.alpha = 1.0;
        UIView.animate(withDuration: 1.2, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] _ in self?.alpha = 1.0 })
    }
}
