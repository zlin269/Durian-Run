//
//  OnboardingViewController.swift
//  Durian Run
//
//  Created by Han Liu on 9/4/21.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController, UITextFieldDelegate {
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.textfield.delegate = self
        view.addGestureRecognizer(tap)
        
        switch UserDefaults.string(forKey: .language) {
        case "English":
            titleLabel.text = "Hello! What's your name?"
            textfield.placeholder = "nikename no more than 8 characters"
            continuebtn.setTitle("Continue", for: .normal)
        case "Chinese":
            titleLabel.text = "你好，请问怎么称呼？"
            textfield.placeholder = "请输入8字以内的昵称"
            continuebtn.setTitle("继续", for: .normal)
        case "Thai":
            titleLabel.text = "สวัสดีคุณชื่ออะไร?"
            textfield.placeholder = "กรุณาใส่ชื่อเล่นไม่เกิน 8 ตัวอักษร"
            continuebtn.setTitle("ดำเนินต่อ", for: .normal)
        default:
            break
        }
    }
    
    @IBAction func avatar1Selected(_ sender: UIButton) {
        avatarButtons.forEach({$0.setImage(nil, for: .normal) })
        
        sender.setImage(btnSelectedImage , for: .normal)
        avatar = sender.restorationIdentifier!
    }
    
    
    @IBAction func continuePressed(_ sender: Any) {
        UserDefaults.set(value:avatar, forKey: .avatar)
        print("avatar set to "+avatar)
        
        // MARK: - add username constrain check
        let usernameTyped = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if usernameTyped.removingWhitespaces() == "" {
            showEmptyAlert()
            return
        } else if usernameTyped.count > 8 {
            showTooLongAlert()
            return
        }
        UserDefaults.set(value: true, forKey: .hasSetName)
        UserDefaults.set(value: usernameTyped, forKey: .username)
        print("username set to " + usernameTyped)

    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func showEmptyAlert () {
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
            alert = UIAlertController(title: "Attention", message: "Nickname cannot be white space", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        }
            // show the alert
            self.present(alert, animated: true, completion: nil)
    }
    
    func showTooLongAlert () {
        var alert:UIAlertController
        switch UserDefaults.string(forKey: .language) {
        case "Chinese":
            alert = UIAlertController(title: "注意", message: "昵称过长", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: UIAlertAction.Style.default, handler: nil))
        case "English":
            alert = UIAlertController(title: "Attention", message: "Nickname is too long", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        case "Thai":
            alert = UIAlertController(title: "ความสนใจ", message: "ชื่อเล่นยาวเกินไป", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ตกลง", style: UIAlertAction.Style.default, handler: nil))
        default:
            alert = UIAlertController(title: "Attention", message: "Nickname cannot be white space", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        }
            // show the alert
            self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
