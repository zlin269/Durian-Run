//
//  SettingsContainerViewController.swift
//  Durian Run
//

import UIKit

class GameSettingsViewController: UIViewController {
    private var volume: Double = {
        let volumeValue = UserDefaults.double(forKey: .gameVolume)
        return volumeValue ?? 1.0
    }()
    private var music: Double = {
        let musicValue = UserDefaults.double(forKey: .musicVolume)
        return musicValue ?? 1.0
    }()
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var musicSlider: UISlider!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        volumeSlider.value = Float(volume)
        musicSlider.value = Float(music)
        
        updateSubviews()
    }
    
    private func updateSubviews() {
        switch UserDefaults.string(forKey: .language) {
        case "Chinese":
            settingsLabel.text = "设置"
            volumeLabel.text = "游戏音量" + " " + String(format: "%.2f", volume)
            musicLabel.text = "音乐音量" + " " + String(format: "%.2f", music)
            languageLabel.text = "语言"
        case "English":
            settingsLabel.text = "Settings"
            volumeLabel.text = "Game Volume" + " " + String(format: "%.2f", volume)
            musicLabel.text = "Music Volume" + " " + String(format: "%.2f", music)
            languageLabel.text = "Language"
        case "Thai":
            settingsLabel.text = "การตั้งค่า"
            volumeLabel.text = "ปริมาณเกม" + " " + String(format: "%.2f", volume)
            musicLabel.text = "ระดับเสียงเพลง" + " " + String(format: "%.2f", music)
            languageLabel.text = "ภาษา"
        default:
            break
        }
    }
    
    @IBAction func dismissButtonSelector(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("UpdateGameScene"), object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func adjustVolume(_ sender: UISlider) {
        volume = Double(volumeSlider.value)
        UserDefaults.set(value: volume, forKey: .gameVolume)
        updateSubviews()
    }
    
    @IBAction func adjustMusicVolume(_ sender: UISlider) {
        music = Double(musicSlider.value)
        UserDefaults.set(value: music, forKey: .musicVolume)
        updateSubviews()
    }
    
    @IBAction func changeLanguage(_ sender: UISegmentedControl) {
        let list = ["Chinese", "Thai", "English"]
        UserDefaults.set(value: list[min(sender.selectedSegmentIndex, 2)], forKey: .language)
        updateSubviews()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
