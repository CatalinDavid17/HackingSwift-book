//
//  WhackSlot.swift
//  Project14
//
//  Created by Catalin David on 23/08/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {

	var charNode: SKSpriteNode!
	var visible = false
	var isHit = false
	var popupTime = 0.85
	
	func configureAtPosition(pos: CGPoint) {
		position = pos
		let sprite = SKSpriteNode(imageNamed: "whackHole")
		addChild(sprite)
		
		let cropNode = SKCropNode()
		cropNode.position = CGPoint(x: 0, y: 15)
		cropNode.zPosition = 1
		cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
		
		charNode = SKSpriteNode(imageNamed: "penguinGood")
		charNode.position = CGPoint(x: 0, y: -90)
		charNode.name = "character"
		cropNode.addChild(charNode)
		addChild(cropNode)
	}
	
	func show(hideTime hideTime: Double) {
		if visible { return }
		
		charNode.runAction(SKAction.moveByX(0, y: 80, duration: 0.05))
		visible = true
		isHit = false
		
		if RandomInt(min: 0, max: 2) == 0 {
			charNode.texture = SKTexture(imageNamed: "penguinGood")
			charNode.name = "charFriend"
		} else {
			charNode.texture = SKTexture(imageNamed: "penguinEvil")
			charNode.name = "charEnemy"
		}
		
		RunAfterDelay(hideTime * 3.5) { [unowned self] in
			self.hide()
		}
	}
	
	func hide() {
		if !visible { return }
		
		charNode.runAction(SKAction.moveByX(0, y: -80, duration: 0.05))
		visible = false
	}
}
