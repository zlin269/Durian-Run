//
//  LeaderboardViewController.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/16.
//

import Foundation
import UIKit
import GameKit

class LeaderboardViewController: UIViewController, GKGameCenterControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticatePlayer()
        
        let allSubviews = view.subviews
        for v in allSubviews {
            if let textView = v as? UITextView {
                textView.text = "Best Score: " + String(UserDefaults.int(forKey: .highScore) ?? 0) + "\n"
                let season = Season.init(rawValue: (UserDefaults.int(forKey: .mostSeasons) ?? 0)%4)?.description
                let year = String((UserDefaults.int(forKey: .mostSeasons) ?? 0) / 4 + Calendar.current.component(.year, from: Date()))
                textView.text += "Longest Survival time: The " + season! + " of " + year
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    func authenticatePlayer () {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler =  {
            (view, error) in
            if view != nil {
                self.present(view!, animated: true, completion: nil)
            } else {
                print(GKLocalPlayer.local.isAuthenticated)
            }
        }
    }
    
    func saveHighScore (number : Int) {
        if GKLocalPlayer.local.isAuthenticated {
            GKLeaderboard.submitScore(number, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [""], completionHandler: {_ in })
            
        }
    }
    
    func showGameCenter () {
        let viewController = self.view.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        gcvc.gameCenterDelegate = self
        viewController?.present(gcvc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
}
