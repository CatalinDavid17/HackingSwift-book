//
//  GameScene.swift
//  Project14
//
//  Created by Catalin David on 23/08/16.
//  Copyright (c) 2016 Catalin David. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	
	var slots = [WhackSlot]()
	var gameScore: SKLabelNode!
	var score: Int = 0 {
		didSet {
			gameScore.text = "Score: \(score)"
		}
	}
	
	//MARK: Helper methods
	
	func createSlotAt(pos: CGPoint) {
		let slot = WhackSlot()
		slot.configureAtPosition(pos)
		addChild(slot)
		slots.append(slot)
	}

    override func didMoveToView(view: SKView) {
		let background = SKSpriteNode(imageNamed: "whackBackground")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .Replace
		background.zPosition = -1
		addChild(background)
		
		gameScore = SKLabelNode(fontNamed: "Chalkduster")
		gameScore.text = "Score: 0"
		gameScore.position = CGPoint(x: 122, y: 8)
		gameScore.fontSize = 48
		addChild(gameScore)
		
		for i in 0 ..< 5 {
			createSlotAt(CGPoint(x: 100 + (i * 170), y: 410))
		}
		for i in 0 ..< 4 {
			createSlotAt(CGPoint(x: 180 + (i * 170), y: 320))
		}
		for i in 0 ..< 5 {
			createSlotAt(CGPoint(x: 100 + (i * 170), y: 230))
		}
		for i in 0 ..< 4 {
			createSlotAt(CGPoint(x: 180 + (i * 170), y: 140))
		}
	}
	
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
	
	}
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
	
	
}
