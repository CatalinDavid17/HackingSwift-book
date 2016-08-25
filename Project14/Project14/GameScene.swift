//
//  GameScene.swift
//  Project14
//
//  Created by Catalin David on 23/08/16.
//  Copyright (c) 2016 Catalin David. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
	
	var slots = [WhackSlot]()
	var gameScore: SKLabelNode!
	var popupTime = 0.85
	var numRounds = 0
	
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
	
	func createEnemy() {
		numRounds = numRounds + 1
		
		if numRounds >= 40 {
			for slot in slots {
				slot.hide()
			}
			
			let gameOver = SKSpriteNode(imageNamed: "gameOver")
			gameOver.position = CGPoint(x: 512, y: 384)
			gameOver.zPosition = 1
			addChild(gameOver)
			
			return
		}
		
		popupTime = popupTime * 0.991
		
		slots = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(slots) as! [WhackSlot]
		slots[0].show(hideTime: popupTime)
		
		if RandomInt(min: 0, max: 12) > 4 {
			slots[1].show(hideTime: popupTime)
		}
		if RandomInt(min: 0, max: 12) > 8 {
			slots[2].show(hideTime: popupTime)
		}
		if RandomInt(min: 0, max: 12) > 10 {
			slots[3].show(hideTime: popupTime)
		}
		if RandomInt(min: 0, max: 12) > 11 {
			slots[4].show(hideTime: popupTime)
		}
		
		let minDelay = popupTime / 2.0
		let maxDelay = popupTime * 2
		
		RunAfterDelay(RandomDouble(min: minDelay, max: maxDelay)) { [unowned self] in
			self.createEnemy()
		}
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
		
		RunAfterDelay(1) { [unowned self] in
  			 self.createEnemy()
		}
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.locationInNode(self)
			let nodes = nodesAtPoint(location)
			
			for node in nodes {
				if node.name == "charFriend" {
					let whackSlot = node.parent!.parent as! WhackSlot
					if !whackSlot.visible { continue }
					if whackSlot.isHit { continue }
					
					whackSlot.hit()
					score = score - 5
					
					runAction(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
				} else if node.name == "charEnemy" {
					let whackSlot = node.parent!.parent as! WhackSlot
					if !whackSlot.visible { continue }
					if whackSlot.isHit { continue }
					
					whackSlot.charNode.xScale = 0.85
					whackSlot.charNode.yScale = 0.85
					
					whackSlot.hit()
					score = score + 1
					
					runAction(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
				}
			}
		}
	}
	
	override func update(currentTime: CFTimeInterval) {
		/* Called before each frame is rendered */
	}
	
}
