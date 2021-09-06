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
        if usernameTyped?.removingWhitespaces() == "" {
            showAlert()
        }
        UserDefaults.set(value: usernameTyped ?? "You", forKey: .username)
        print("username set to "+usernameTyped!)

    }
    
    func showAlert () {
        var alert:UIAlertController
        switch UserDefaults.string(forKey: .language) {
        case "Chinese":
            alert = UIAlertController(title: "注意", message: "昵称不能为空", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: UIAlertAction.Style.default, handler: nil))
        case "English":
            alert = UIAlertController(title: "Attention", message: "Nickname cannot be white space", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        case "Thai":
            alert = UIAlertController(title: "ความสนใจ", message: "กรุณากดปุ่มยอมรับเพื่อดำเนินการต่อ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ตกลง", style: UIAlertAction.Style.default, handler: nil))
        default:
            alert = UIAlertController(title: "Attention", message: "Please Press the Accept Button to continue", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        }
            // show the alert
            self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
