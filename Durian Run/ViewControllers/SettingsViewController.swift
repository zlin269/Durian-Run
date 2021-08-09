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

    override func viewDidLoad() {
        super.viewDidLoad()
        
		let allSubviews = view.subviews
		for subview in allSubviews where subview is UIScrollView {
			scrollView = subview as? UIScrollView
		}
		scrollView.isScrollEnabled = true
		scrollView.bounces = true
		scrollView.showsVerticalScrollIndicator = true
		scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height * 3)
		
		let viewInScrollView = UIView(frame: CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height * 2))
		scrollView.addSubview(viewInScrollView)
		viewInScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
		viewInScrollView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: 0).isActive = true
        
		volume = UserDefaults.double(forKey: .gameVolume) ?? 1
	
        let volumeName = UILabel()
		volumeName.translatesAutoresizingMaskIntoConstraints = false
		volumeName.text = "Game Volume"
		viewInScrollView.addSubview(volumeName)
		volumeName.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 50).isActive = true
		volumeName.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: 0).isActive = true
		
        volumeSlider = UISlider()
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.minimumValue = 0
        volumeSlider.maximumValue = 1
        volumeSlider.isContinuous = true
        volumeSlider.addTarget(self, action: #selector(adjustVolume(_:)), for: .valueChanged)
		volumeSlider.value = Float(volume)
		viewInScrollView.addSubview(volumeSlider)
        volumeSlider.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 100).isActive = true
        volumeSlider.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: -10).isActive = true
        volumeSlider.widthAnchor.constraint(equalToConstant: 150).isActive = true
        volumeSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        volumeLabel = UILabel()
        volumeLabel.translatesAutoresizingMaskIntoConstraints = false
        volumeLabel.text = String(format: "%.2f", volume)
		viewInScrollView.addSubview(volumeLabel)
		
		
        volumeLabel.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 100).isActive = true
        volumeLabel.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: 100).isActive = true
        
		music = UserDefaults.double(forKey: .musicVolume) ?? 1
		
		let musicName = UILabel()
		musicName.translatesAutoresizingMaskIntoConstraints = false
		musicName.text = "Music Volume"
		viewInScrollView.addSubview(musicName)
		musicName.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 150).isActive = true
		musicName.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: 0).isActive = true
        
        musicSlider = UISlider()
        musicSlider.translatesAutoresizingMaskIntoConstraints = false
        musicSlider.minimumValue = 0
        musicSlider.maximumValue = 1
        musicSlider.isContinuous = true
        musicSlider.addTarget(self, action: #selector(adjustMusicVolume(_:)), for: .valueChanged)
		musicSlider.value = Float(music)
		viewInScrollView.addSubview(musicSlider)
        musicSlider.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 200).isActive = true
        musicSlider.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: -10).isActive = true
        musicSlider.widthAnchor.constraint(equalToConstant: 150).isActive = true
        musicSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        musicLabel = UILabel()
        musicLabel.translatesAutoresizingMaskIntoConstraints = false
        musicLabel.text = String(format: "%.2f", music)
		viewInScrollView.addSubview(musicLabel)
        musicLabel.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 200).isActive = true
        musicLabel.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: 100).isActive = true
		
		let moreSettings1 = UILabel()
		moreSettings1.translatesAutoresizingMaskIntoConstraints = false
		moreSettings1.text = "Something"
		viewInScrollView.addSubview(moreSettings1)
		moreSettings1.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 300).isActive = true
		moreSettings1.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: 0).isActive = true
		
		let moreSettings2 = UILabel()
		moreSettings2.translatesAutoresizingMaskIntoConstraints = false
		moreSettings2.text = "Something"
		viewInScrollView.addSubview(moreSettings2)
		moreSettings2.topAnchor.constraint(equalTo: viewInScrollView.topAnchor, constant: 500).isActive = true
		moreSettings2.centerXAnchor.constraint(equalTo: viewInScrollView.centerXAnchor, constant: 0).isActive = true
        

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
