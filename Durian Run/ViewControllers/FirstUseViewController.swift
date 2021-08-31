//
//  FirstUseController.swift
//  Durian Run
//
//  Created by Han Liu on 8/23/21.
//

import Foundation
import UIKit

class FirstUseViewController: UIViewController {

    @IBOutlet weak var chineseButton: UIButton!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var thaiButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var languageSettingLabel: UILabel!
    @IBOutlet weak var protocolText: UITextView!
    
    var languageSet:String = "English"
    
    
    override func viewDidAppear(_ animated: Bool) {
        if(UserDefaults.bool(forKey: .hasFirstAccepted) ?? false) { //not first open and has accepted terms
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let startingViewController = storyBoard.instantiateViewController(withIdentifier: "MainMenu")
            self.present(startingViewController, animated: false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        declineButton.isHidden = true
        acceptButton.isHidden = true
        protocolText.isHidden = true
    }

    @IBAction func chooseChinese(_ sender: Any) {
        UserDefaults.set(value: "Chinese", forKey: .language)
        print("Chinese Set")
        languageSet = "Chinese"
       displayUserProtocol()
    }
    
    @IBAction func chooseEnglish(_ sender: Any) {
        UserDefaults.set(value: "English", forKey: .language)
        print("English Set")
        languageSet = "English"
       displayUserProtocol()
    }
    
    @IBAction func chooseThai(_ sender: Any) {
        UserDefaults.set(value: "Thai", forKey: .language)
        print("Thai Set")
        languageSet = "Thai"
       displayUserProtocol()
    }
    
    /* Display textView ans Buttons for Accepting User Protocol
     */
    func displayUserProtocol() {
        chineseButton.isHidden = true
        englishButton.isHidden = true
        thaiButton.isHidden = true
        languageSettingLabel.isHidden = true
        declineButton.isHidden = false
        acceptButton.isHidden = false
        switch languageSet {
        case "Chinese":
            declineButton.setTitle("拒绝", for: .normal)
            acceptButton.setTitle("同意", for: .normal)
        case "English":
            declineButton.setTitle("Decline", for: .normal)
            acceptButton.setTitle("Accept", for: .normal)
        case "Thai":
            declineButton.setTitle("ปฏิเสธ", for: .normal)
            acceptButton.setTitle("ตกลง", for: .normal)
        default:
            declineButton.setTitle("Decline", for: .normal)
            acceptButton.setTitle("Accept", for: .normal)
        }
        protocolText.isHidden = false
        
       showProtocolText(language: languageSet)
        
    }
    
    
    /* Show textView for User Protocal(URL link)
       Note: NSMakeRange is URL starting char and length
     */
    func showProtocolText(language:String){
        var attributedString: NSMutableAttributedString
        //MARK: Change URL later
        let url = URL(string: "https://www.apple.com")!
        
        switch language{
        case "Chinese":
            attributedString = NSMutableAttributedString(string: "感谢您下载榴莲大冒险！\n\n请仔细阅读《正大公司游戏许可及服务协议》后点击同意按钮继续。")
            attributedString.setAttributes([.link: url], range: NSMakeRange(18, 15))
        case "English":
            attributedString = NSMutableAttributedString(string: "Thank you for downloading Durian Run!\n\nPlease carefully read CPG Game License and Service Agreement and then press the Accept button to continue.")
            attributedString.setAttributes([.link: url], range: NSMakeRange(61, 38))
        case "Thai":
            attributedString = NSMutableAttributedString(string: "ขอบคุณสำหรับการดาวน์โหลด Durian Run!\n\nโปรดอ่าน 《ใบอนุญาตเกม CPG และข้อตกลงการบริการ》 อย่างละเอียดแล้วคลิกปุ่มยอมรับเพื่อดำเนินการต่อ")
            attributedString.setAttributes([.link: url], range: NSMakeRange(47, 37))
        default:
            attributedString = NSMutableAttributedString(string: "Thank you for downloading Durian Run!\n\nPlease carefully read CPG Game License and Service Agreement and then press the Accept button to continue.")
            attributedString.setAttributes([.link: url], range: NSMakeRange(61, 38))
        }
        protocolText.attributedText = attributedString
        protocolText.isUserInteractionEnabled = true
        protocolText.font = UIFont.systemFont(ofSize: 14.5)
        // Set how links should appear: orange and underlined
        protocolText.linkTextAttributes = [
            .foregroundColor: UIColor.orange,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
    
    
    @IBAction func pressDecline(_ sender: Any) {
        
        var alert:UIAlertController
        switch languageSet {
        case "Chinese":
            alert = UIAlertController(title: "注意", message: "请点击同意后继续", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: UIAlertAction.Style.default, handler: nil))
        case "English":
            alert = UIAlertController(title: "Attention", message: "Please Press the Accept Button to continue", preferredStyle: .alert)
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
    
    @IBAction func pressAccept(_ sender: Any) {
        UserDefaults.set(value: true, forKey: .hasFirstAccepted)
        UserDefaults.set(value: 1.0, forKey: .gameVolume)
        UserDefaults.set(value: 1.0, forKey: .musicVolume)
        UserDefaults.set(value: 0, forKey: .coins)
        UserDefaults.set(value: 0, forKey: .highScore)
        UserDefaults.set(value: 0, forKey: .mostSeasons)
        UserDefaults.set(value: 0, forKey: .selectedCharacter)
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("scores")
        do {
            print("initializing scores data on disk")
            let scores = [Score(name: "Jack", score: 66666, seasons: 12),
                              Score(name: "Alice", score: 23333, seasons: 6),
                              Score(name: "Lawrence", score: 12345, seasons: 3)]
            let data = try NSKeyedArchiver.archivedData(withRootObject: scores, requiringSecureCoding: false)
            try data.write(to: path)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}
