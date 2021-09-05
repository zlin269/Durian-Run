//
//  OnboardingViewController.swift
//  Durian Run
//
//  Created by Han Liu on 9/4/21.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var monsterbtn1: UIButton!
    @IBOutlet weak var monsterbtn2: UIButton!
    @IBOutlet weak var monsterbtn3: UIButton!
    @IBOutlet weak var monsterbtn4: UIButton!
    @IBOutlet weak var monsterbtn5: UIButton!
    @IBOutlet weak var continuebtn: UIButton!
    
    
    @IBOutlet var avatarButtons: [UIButton]!
    
    var avatar = "littlemonster1"
    let btnSelectedImage = UIImage(named: "selected")
    
    
    
    @IBAction func avatar1Selected(_ sender: UIButton) {
        avatarButtons.forEach({$0.setImage(nil, for: .normal) })
        
        sender.setImage(btnSelectedImage , for: .normal)
        avatar = sender.restorationIdentifier!
    }
    
    
    @IBAction func continuePressed(_ sender: Any) {
        UserDefaults.set(value:avatar, forKey: .avatar)
        print("avatar set to "+avatar)
        
        // MARK: - add username constrain check
        let usernameTyped = textfield.text
        UserDefaults.set(value: usernameTyped ?? "You", forKey: .username)
        print("username set to "+usernameTyped!)
    }
}
