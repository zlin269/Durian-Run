//
//  GameViewController.swift
//  Durian Run
//
//  Created by 林子轩 and Lawrence on 2021/7/16.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    private let gameScene: GameScene? = {
        guard let scene = GKScene(fileNamed: "GameScene"), let sceneNode = scene.rootNode as? GameScene else {
            return nil
        }
        
        return sceneNode
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    override func viewDidLoad() {
        
        // Set the scale mode to scale to fit the window
        gameScene?.scaleMode = .aspectFit
        
        gameScene?.openSettingsClosure = { [weak self] in
            guard let self = self else {
                return
            }
            
            self.openGameSettingsViewController()
        }
        
        // Present the scene
        if let view = self.view as! SKView? {
            view.presentScene(gameScene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = false
            view.showsPhysics = false
            view.showsDrawCount = false
        }
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateGameScene), name: Notification.Name("UpdateGameScene"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("UpdateGameScene"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gameScene?.reloadGameScene()
    }
    
    @objc private func updateGameScene() {
        gameScene?.reloadGameScene()
    }

    override var shouldAutorotate: Bool {
		return true
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
	
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }
    
    public func openGameSettingsViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "GameSettings")
        
        present(settingsViewController, animated: true, completion: nil)
    }
}
