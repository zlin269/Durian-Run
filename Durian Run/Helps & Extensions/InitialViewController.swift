//
//  InitialViewController.swift
//  Durian Run
//
//  Created by 林子轩 on 2021/7/26.
//

import UIKit
import SpriteKit
import GameplayKit

class InitialViewController: UIViewController {
	
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		// Load 'GameScene.sks' as a GKScene. This provides gameplay related content
		// including entities and graphs.
		if let scene = GKScene(fileNamed: "GameScene") {
			
			// Get the SKScene from the loaded GKScene
			if let sceneNode = scene.rootNode as! StartMenuScene? {
				
				// Set the scale mode to scale to fit the window
				sceneNode.scaleMode = .aspectFit
				
				// Present the scene
				if let view = self.view as! SKView? {
					view.presentScene(sceneNode)
					
					view.ignoresSiblingOrder = true
					
					view.showsFPS = true
					view.showsNodeCount = true
					view.showsPhysics = true
				}
			}
		}
		super.viewDidLoad()
		
		
	}
	
	override var shouldAutorotate: Bool {
		return false
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		if UIDevice.current.userInterfaceIdiom == .phone {
			return .landscape
		} else {
			return .landscape
		}
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	
}
