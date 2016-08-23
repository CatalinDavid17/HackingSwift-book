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
		
	
}
