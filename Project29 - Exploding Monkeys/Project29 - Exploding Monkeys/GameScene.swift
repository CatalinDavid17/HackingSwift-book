//
//  GameScene.swift
//  Project29 - Exploding Monkeys
//
//  Created by Catalin David on 28/09/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
	case Banana = 1
	case Building = 2
	case Player = 4
}

class GameScene: SKScene {
	
	private var buildings = [BuildingNode]()
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
		backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
		
		createBuildings()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
	}
    
    override func update(_ currentTime: TimeInterval) {

    }
	
	func createBuildings() {
		var currentX: CGFloat = -15
		
		while currentX < 1024 {
			let size = CGSize(width: RandomInt(min: 2, max: 4) * 40, height: RandomInt(min: 300, max: 600))
			currentX += size.width + 2
			
			let building = BuildingNode(color: UIColor.red, size: size)
			building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
			building.setup()
			addChild(building)
			
			buildings.append(building)
		}
	}
}
