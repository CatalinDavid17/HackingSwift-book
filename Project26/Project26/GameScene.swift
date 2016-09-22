//
//  GameScene.swift
//  Project26
//
//  Created by Catalin David on 21/09/16.
//  Copyright (c) 2016 Catalin David. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum CollisionTypes: UInt32 {
	case Player = 1
	case Wall = 2
	case Star = 4
	case Vortex = 8
	case Finish = 16
}

class GameScene: SKScene {
	
	var player: SKSpriteNode!
	var lastTouchPosition: CGPoint?
	var motionManager: CMMotionManager!
	
    override func didMoveToView(view: SKView) {
		let background = SKSpriteNode(imageNamed: "background.jpg")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .Replace
		background.zPosition = -1
		addChild(background)
		
		loadLevel()
		createPlayer()
		
		physicsWorld.gravity = CGVector(dx: 0, dy: 0)
		
		motionManager = CMMotionManager()
		motionManager.startAccelerometerUpdates()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.locationInNode(self)
			lastTouchPosition = location
		}
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let touch = touches.first {
			let location = touch.locationInNode(self)
			lastTouchPosition = location
		}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		lastTouchPosition = nil
	}
	
	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		lastTouchPosition = nil
	}
   
    override func update(currentTime: CFTimeInterval) {
		#if (arch(i386) || arch(x86_64))
			if let currentTouch = lastTouchPosition {
				let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
				physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
			}
		#else
			if let accelerometerData = motionManager.accelerometerData {
				physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
			}
		#endif
	}
	
}

extension GameScene {
	private func loadLevel() {
		if let levelPath = NSBundle.mainBundle().pathForResource("level1", ofType: "txt") {
			if let levelString = try? String(contentsOfFile: levelPath, usedEncoding: nil) {
				let lines = levelString.componentsSeparatedByString("\n")
				
				for (row, line) in lines.reverse().enumerate() {
					for (column, letter) in line.characters.enumerate() {
						let position = CGPoint(x: (64 * column) + 35, y: (46 * row) + 130)
						
						if letter == "x" {
							let node = SKSpriteNode(imageNamed: "block")
							node.size = CGSize(width: 64, height: 45)
							node.position = position
							node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
							node.physicsBody!.categoryBitMask = CollisionTypes.Wall.rawValue
							node.physicsBody!.dynamic = false
							addChild(node)
						} else if letter == "v" {
							let node = SKSpriteNode(imageNamed: "vortex")
							node.position = position
							node.name = "vortex"
							node.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)))
							node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
							node.physicsBody!.dynamic = false
							node.physicsBody!.categoryBitMask = CollisionTypes.Vortex.rawValue
							node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
							node.physicsBody!.collisionBitMask = 0
							addChild(node)
						} else if letter == "s" {
							let node = SKSpriteNode(imageNamed: "star")
							node.name = "star"
							node.size = CGSize(width: 45, height: 45)
							node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
							node.physicsBody!.dynamic = false
							node.physicsBody!.categoryBitMask = CollisionTypes.Star.rawValue
							node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
							node.physicsBody!.collisionBitMask = 0
							node.position = position
							addChild(node)
						} else if letter == "f" {
							let node = SKSpriteNode(imageNamed: "finish")
							node.name = "finish"
							node.size = CGSize(width: 45, height: 45)
							node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
							node.physicsBody!.dynamic = false
							node.physicsBody!.categoryBitMask = CollisionTypes.Finish.rawValue
							node.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue
							node.physicsBody!.collisionBitMask = 0
							node.position = position
							addChild(node)
						}
					}
				}
			}
		}
	}
	
	private func createPlayer() {
		player = SKSpriteNode(imageNamed: "player")
		player.size = CGSize(width: 40, height: 40)
		player.position = CGPoint(x: 90, y: 620)
		player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
		player.physicsBody!.allowsRotation = false
		player.physicsBody!.linearDamping = 0.5
		
		player.physicsBody!.categoryBitMask = CollisionTypes.Player.rawValue
		player.physicsBody!.contactTestBitMask = CollisionTypes.Star.rawValue | CollisionTypes.Vortex.rawValue | CollisionTypes.Finish.rawValue
		player.physicsBody!.collisionBitMask = CollisionTypes.Wall.rawValue
		addChild(player)
	}
}
