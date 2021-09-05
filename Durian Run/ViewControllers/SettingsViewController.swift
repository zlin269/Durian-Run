//
//  SettingsViewController.swift
//  Runner3D
//
//  Created by Zixuan(Jack)Lin on 5/22/19.
//  Copyright © 2019 Zixuan(Jack)Lin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var volume: Double = 1
    var music: Double = 1
    
	var scrollView: UIScrollView!
    var volumeSlider: UISlider!
    var volumeLabel: UILabel!
    var musicSlider: UISlider!
    var musicLabel: UILabel!
    var languageSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
		let allSubviews = view.subviews
		for subview in allSubviews {
            if subview is UIScrollView {
                scrollView = subview as? UIScrollView
            }
            if subview.restorationIdentifier == "Title" {
                (subview as! UILabel).text = {()-> String in switch UserDefaults.string(forKey: .language) {
                case "Chinese": return "设置"
                case "English": return "Settings"
                case "Thai": return "การตั้งค่า"
                default: return "Settings"
                }}()
                (subview as! UILabel).adjustsFontSizeToFitWidth = true
            }
		}
		scrollView.isScrollEnabled = true
		scrollView.bounces = true
		scrollView.showsVerticalScrollIndicator = true
		scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height * 3)
        for v in scrollView.subviews {
            v.removeFromSuperview()
        }
		
		let viewInScrollView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 400))
		scrollView.addSubview(viewInScrollView)
		viewInScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
		viewInScrollView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        
		volume = UserDefaults.double(forKey: .gameVolume)!
	
        let volumeName = UILabel()
		volumeName.translatesAutoresizingMaskIntoConstraints = false
        volumeName.text = {()->String in switch UserDefaults.string(forKey: .language) {
        case "Chinese": return "游戏音量"
        case "English": return "Game Volume"
        case "Thai": return "ปริมาณเกม"
        default: return "Game Volume"
        }}()
		viewInScrollView.addSubview(volumeName)
		volumeName.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 20).isActive = true
		volumeName.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: 0).isActive = true
		
        volumeSlider = UISlider()
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.minimumValue = 0
        volumeSlider.maximumValue = 1
        volumeSlider.isContinuous = true
        volumeSlider.addTarget(self, action: #selector(adjustVolume(_:)), for: .valueChanged)
		volumeSlider.value = Float(volume)
		viewInScrollView.addSubview(volumeSlider)
        volumeSlider.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 70).isActive = true
        volumeSlider.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: -25).isActive = true
        volumeSlider.widthAnchor.constraint(equalToConstant: 150).isActive = true
        volumeSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        volumeLabel = UILabel()
        volumeLabel.translatesAutoresizingMaskIntoConstraints = false
        volumeLabel.text = String(format: "%.2f", volume)
		viewInScrollView.addSubview(volumeLabel)
		
		
        volumeLabel.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 70).isActive = true
        volumeLabel.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: 85).isActive = true
        
		music = UserDefaults.double(forKey: .musicVolume)!
		
		let musicName = UILabel()
		musicName.translatesAutoresizingMaskIntoConstraints = false
		musicName.text = {()->String in switch UserDefaults.string(forKey: .language) {
        case "Chinese": return "音乐音量"
        case "English": return "Music Volume"
        case "Thai": return "ระดับเสียงเพลง"
        default: return "Music Volume"
        }}()
		viewInScrollView.addSubview(musicName)
		musicName.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 120).isActive = true
		musicName.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: 0).isActive = true
        
        musicSlider = UISlider()
        musicSlider.translatesAutoresizingMaskIntoConstraints = false
        musicSlider.minimumValue = 0
        musicSlider.maximumValue = 1
        musicSlider.isContinuous = true
        musicSlider.addTarget(self, action: #selector(adjustMusicVolume(_:)), for: .valueChanged)
		musicSlider.value = Float(music)
		viewInScrollView.addSubview(musicSlider)
        musicSlider.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 170).isActive = true
        musicSlider.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: -25).isActive = true
        musicSlider.widthAnchor.constraint(equalToConstant: 150).isActive = true
        musicSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        musicLabel = UILabel()
        musicLabel.translatesAutoresizingMaskIntoConstraints = false
        musicLabel.text = String(format: "%.2f", music)
		viewInScrollView.addSubview(musicLabel)
        musicLabel.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 170).isActive = true
        musicLabel.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: 85).isActive = true
		
		let languageLabel = UILabel()
		languageLabel.translatesAutoresizingMaskIntoConstraints = false
		languageLabel.text = {()->String in switch UserDefaults.string(forKey: .language) {
        case "Chinese": return "语言"
        case "English": return "Language"
        case "Thai": return "ภาษา"
        default: return "Language"
        }}()
		viewInScrollView.addSubview(languageLabel)
		languageLabel.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 220).isActive = true
		languageLabel.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: 0).isActive = true
        
        languageSegmentedControl = UISegmentedControl(items: ["中文", "English", "ไทย"])
        languageSegmentedControl.selectedSegmentIndex = (UserDefaults.string(forKey: .language)?.toLanguageIndex())!
        languageSegmentedControl.addTarget(self, action: #selector(changeLanguage(_:)), for: .valueChanged)
        viewInScrollView.addSubview(languageSegmentedControl)
        languageSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        languageSegmentedControl.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 270).isActive = true
        languageSegmentedControl.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: 0).isActive = true
		
        let resetID = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        resetID.translatesAutoresizingMaskIntoConstraints = false
        resetID.titleLabel?.text = {()->String in switch UserDefaults.string(forKey: .language) {
        case "Chinese": return "更变用户名或头像"
        case "English": return "Change Name or Avatar"
        case "Thai": return "เปลี่ยนชื่อผู้ใช้หรืออวาตาร์"
        default: return "更变用户名或头像"
        }}()
		viewInScrollView.addSubview(resetID)
        resetID.addTarget(self, action: #selector(setNameAndAvatar(_:)), for: .touchUpInside)
        resetID.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 320).isActive = true
        resetID.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: 0).isActive = true
        

        // Do any additional setup after loading the view.
    }
    
    @objc func adjustVolume(_ sender: UISlider!) {
        volume = Double(volumeSlider.value)
        volumeLabel.text = String(format: "%.2f", volume)
		UserDefaults.set(value: volume, forKey: .gameVolume)
    }
    
    @objc func adjustMusicVolume(_ sender: UISlider!) {
        music = Double(musicSlider.value)
        musicLabel.text = String(format: "%.2f", music)
		UserDefaults.set(value: music, forKey: .musicVolume)
    }
    
    @objc func changeLanguage (_ sender: UISegmentedControl!) {
        var language : String
        var title : String
        var message : String
        switch languageSegmentedControl.selectedSegmentIndex {
        case 0:
            language = "Chinese"
            title = "语言已设置"
            message = "新的语言设置将会在下一次打开新的页面时启用"
        case 1:
            language = "English"
            title = "Language Set"
            message = "The new language setting will be applied when a new page is opened."
        case 2:
            language = "Thai"
            title = "ภาษาถูกตั้งค่า"
            message = "การตั้งค่าภาษาใหม่จะเปิดใช้งานในครั้งต่อไปที่คุณเปิดหน้าใหม่"
        default:
            language = "English"
            title = "Language Set"
            message = "The new language setting will be applied when a new page is opened."
        }
        UserDefaults.set(value: language, forKey: .language)
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//        NSLog("The \"OK\" alert occured.")
//        }))
//        self.present(alert, animated: true, completion: nil)
        viewDidLoad()
    }
    
    @objc func setNameAndAvatar(_ sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "onboarding")
        vc.view.frame = (self.view?.frame)!
        vc.view.layoutIfNeeded()
        UIView.transition(with: self.view!, duration: 0.3, options: .transitionCrossDissolve, animations:
                            {
                                self.view?.window?.rootViewController = vc
                            }, completion: { completed in
                            })
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

}
