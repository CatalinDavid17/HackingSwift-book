//
//  GameViewController.swift
//  Project20 - Fireworks
//
//  Created by Catalin David on 01/09/16.
//  Copyright (c) 2016 Catalin David. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
	
	override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
		let skView = view as! SKView
		let gameScene = skView.scene as! GameScene
		gameScene.explodeFireworks()
	}
	
}
