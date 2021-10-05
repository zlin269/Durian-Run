//
//  LeaderboardViewController.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/8/16.
//

import Foundation
import UIKit
import GameKit

class LeaderboardViewController: UIViewController, GKGameCenterControllerDelegate, UIScrollViewDelegate {
    
    let nameColor = UIColor(red: 237.0/255.0, green: 30.0/255.0, blue: 121.0/255.0, alpha: 1)
    let scoresPerPage = 6
    
    private var background : UIView!
    private var shanghai : UIView!
    private var titleImage : UIView!
    private var bar : UIView!
    private var top3: UIView!
    private var scrollView : UIScrollView!
    private var listCount : Int = 3
    private var list : [Score]!
    private var avatar1 : UIImageView!, avatar2 : UIImageView!, avatar3 : UIImageView!
    private var top1name : UILabel!, top2name : UILabel!, top3name : UILabel!
    private var top1score : UILabel!, top2score : UILabel!, top3score : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //authenticatePlayer()
        
        
        let allSubviews = view.subviews[0].subviews
        for v in allSubviews {
            if v.restorationIdentifier == "shanghai" {
                shanghai = v
            } else if v.restorationIdentifier == "leaderboardbackground" {
                background = v
            } else if v.restorationIdentifier == "title" {
                titleImage = v
            } else if v.restorationIdentifier == "top3" {
                top3 = v
            } else if v.restorationIdentifier == "bar" {
                bar = v
            } else if v.restorationIdentifier == "scrollView" {
                scrollView = v as? UIScrollView
            } else if v.restorationIdentifier == "top1avatar" {
                avatar1 = v as? UIImageView
            } else if v.restorationIdentifier == "top2avatar" {
                avatar2 = v as? UIImageView
            } else if v.restorationIdentifier == "top3avatar" {
                avatar3 = v as? UIImageView
            } else if v.restorationIdentifier == "top1name" {
                top1name = v as? UILabel
            } else if v.restorationIdentifier == "top2name" {
                top2name = v as? UILabel
            } else if v.restorationIdentifier == "top3name" {
                top3name = v as? UILabel
            } else if v.restorationIdentifier == "top1score" {
                top1score = v as? UILabel
            } else if v.restorationIdentifier == "top2score" {
                top2score = v as? UILabel
            } else if v.restorationIdentifier == "top3score" {
                top3score = v as? UILabel
            }
        }
        self.view.sendSubviewToBack(top3)
        self.view.bringSubviewToFront(titleImage)
        self.view.bringSubviewToFront(scrollView)
        self.view.bringSubviewToFront(bar)
        self.view.sendSubviewToBack(background)
        self.view.sendSubviewToBack(shanghai)
        
        scrollView.delegate = self
        // Top1
        top1name.textColor = nameColor
        
        // Top2
        top2name.textColor = nameColor
        
        // Top3
        top3name.textColor = nameColor
        // Do any additional setup after loading the view.
        
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height + 1)
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("scores")

        do {
            let data = try Data(contentsOf: path)
            if let scores = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Score] {
                list = scores
                // update top 3 scores and names
                top1name.text = scores[0].playerName
                top1score.text = "\(scores[0].score)"
                avatar1.image = UIImage(named: scores[0].avatar)
                top2name.text = scores[1].playerName
                top2score.text = "\(scores[1].score)"
                avatar2.image = UIImage(named: scores[1].avatar)
                top3name.text = scores[2].playerName
                top3score.text = "\(scores[2].score)"
                avatar3.image = UIImage(named: scores[2].avatar)
                // top 4 - 10
                for i in 3...8 {
                    if scores.count == i {
                        break
                    }
                    listCount += 1
                    _ = createBoxWithScore(rank: listCount, avatarImg: list[listCount - 1].avatar, name: list[listCount - 1].playerName, score: list[listCount - 1].score)
                }
            }
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
        var r = list.firstIndex(where: { s in
            return s.playerName == UserDefaults.string(forKey: .username)
        })
        if r != nil {
            r! += 1
        }
        let personalBox = createBoxWithScore(rank: r, avatarImg: UserDefaults.string(forKey: .avatar)!, name: UserDefaults.string(forKey: .username)!, score: r == nil ? 0 : list[r!-1].score)
        personalBox.removeFromSuperview()
        view.addSubview(personalBox)
        view.bringSubviewToFront(personalBox)
        personalBox.removeConstraints(personalBox.constraints)
        personalBox.centerXAnchor.constraint(equalTo: bar.centerXAnchor).isActive = true
        personalBox.centerYAnchor.constraint(equalTo: bar.centerYAnchor).isActive = true
        personalBox.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: CGFloat(1)/CGFloat(scoresPerPage)).isActive = true
        personalBox.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        for v in personalBox.arrangedSubviews where v is UILabel {
            if let l = v as? UILabel {
                if l.textColor != nameColor {
                    l.textColor = .white
                }
            }
        }
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
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height && listCount < list.count {
                print("triggered")
            scrollView.contentSize.height += scrollView.frame.height
            for i in 0...5 {
                if listCount >= list.count {
                    scrollView.contentSize.height -= (scrollView.frame.height / CGFloat(scoresPerPage) * CGFloat(scoresPerPage - i))
                    break
                }
                listCount += 1
                _ = createBoxWithScore(rank: listCount, avatarImg: list[listCount - 1].avatar, name: list[listCount - 1].playerName, score: list[listCount - 1].score)
            }
        }
    }
    
    func createBoxWithScore (rank: Int?, avatarImg : String ,name : String, score : Int) -> UIStackView {
        let box = UIStackView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height / CGFloat(scoresPerPage)))
        box.axis = .horizontal
        box.spacing = 20
        box.distribution = .fillProportionally
        scrollView.addSubview(box)
        box.translatesAutoresizingMaskIntoConstraints = false
        box.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: scrollView.frame.height / CGFloat(scoresPerPage) * CGFloat(listCount - 4)).isActive = true
        box.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        box.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: CGFloat(1)/CGFloat(scoresPerPage)).isActive = true
        box.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        // rank number
        let rankLabel = UILabel(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width * 0.1, height: scrollView.frame.width * 0.1))
        if let r = rank {
            rankLabel.text = "\(r)"
        } else {
            rankLabel.text = "?"
        }
        rankLabel.textAlignment = .right
        rankLabel.textColor = .black
        rankLabel.font = UIFont(name: "Futura-Medium", size: 20)
        box.addArrangedSubview(rankLabel)
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.widthAnchor.constraint(equalTo: box.widthAnchor, multiplier: 0.1).isActive = true
        // player avatar
        let avatar = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width * 0.1, height: scrollView.frame.width * 0.1))
        avatar.image = UIImage(named: avatarImg)
        box.addArrangedSubview(avatar)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.heightAnchor.constraint(equalTo: box.heightAnchor, multiplier: 0.8).isActive = true
        avatar.widthAnchor.constraint(equalTo: avatar.heightAnchor).isActive = true
        // name
        let playerName = UILabel(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width * 0.3, height: scrollView.frame.width * 0.1))
        playerName.text = "\(name)"
        playerName.font = UIFont(name: "Futura-Medium", size: 20)
        playerName.textAlignment = .left
        playerName.textColor = nameColor
        box.addArrangedSubview(playerName)
        playerName.translatesAutoresizingMaskIntoConstraints = false
        playerName.widthAnchor.constraint(equalTo: box.widthAnchor, multiplier: 0.3).isActive = true
        // score
        let playerScore = UILabel(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width * 0.3, height: scrollView.frame.width * 0.1))
        playerScore.text = "\(score)"
        playerScore.textAlignment = .right
        playerScore.font = UIFont(name: "Futura-Medium", size: 20)
        playerScore.textColor = .black
        box.addArrangedSubview(playerScore)
        
        return box
    }
}

