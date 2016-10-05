//
//  GameScene.swift
//  Project36-CrashyPlanes
//
//  Created by Catalin David on 04/10/16.
//  Copyright (c) 2016 Catalin David. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameState {
	case ShowingLogo
	case Playing
	case Dead
}

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	var player: SKSpriteNode!
	var scoreLabel: SKLabelNode!
	var backgroundMusic: SKAudioNode!
	var logo: SKSpriteNode!
	var gameOver: SKSpriteNode!
	var timer: NSTimer!
	var rockDistance: CGFloat = 67
	var gameState = GameState.ShowingLogo
	var duration: NSTimeInterval = 5.8
	
	var score = 0 {
		didSet {
			scoreLabel.text = "SCORE: \(score)"
		}
	}
    override func didMoveToView(view: SKView) {
		createPlayer()
		createSky()
		createBackground()
		createGround()
		createScore()
		createLogos()
		
		physicsWorld.gravity = CGVectorMake(0.0, -5.0)
		physicsWorld.contactDelegate = self
		
		if let musicURL = NSBundle.mainBundle().URLForResource("music", withExtension: "m4a") {
			backgroundMusic = SKAudioNode(URL: musicURL)
			addChild(backgroundMusic)
		}
	}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		switch gameState {
		case .ShowingLogo:
			gameState = .Playing
			
			let fadeOut = SKAction.fadeOutWithDuration(0.5)
			let remove = SKAction.removeFromParent()
			let wait = SKAction.waitForDuration(0.5)
			let activatePlayer = SKAction.runBlock { [unowned self] in
				self.player.physicsBody?.dynamic = true
				self.initRocks()
			}

			timer = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: #selector(increaseDifficulty), userInfo: nil, repeats: true)
			
			let sequence = SKAction.sequence([fadeOut, wait, activatePlayer, remove])
			logo.runAction(sequence)
			
		case .Playing:
			player.physicsBody?.velocity = CGVectorMake(0, 0)
			player.physicsBody?.applyImpulse(CGVectorMake(0, 20))
		case .Dead:
			let scene = GameScene(fileNamed: "GameScene")!
			scene.scaleMode = .ResizeFill
			let transition = SKTransition.moveInWithDirection(SKTransitionDirection.Right, duration: 1)
			self.view?.presentScene(scene, transition: transition)
    	}
	}
	
    override func update(currentTime: CFTimeInterval) {
		guard player != nil else { return }
		
		let value = player.physicsBody!.velocity.dy * 0.0001
		let rotate = SKAction.rotateByAngle(value, duration: 0.1)
		player.runAction(rotate)
		
		if player.zRotation >= 0.50 {
			player.zRotation = 0.50
		} else if player.zRotation <= -0.50 {
			player.zRotation = -0.50
		}
	}
	
	func didBeginContact(contact: SKPhysicsContact) {
		if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
			if contact.bodyA.node == player {
				contact.bodyB.node?.removeFromParent()
			} else {
				contact.bodyA.node?.removeFromParent()
			}
			
			let sound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
			runAction(sound)
			
			score += 1
			
			return
		}
		
		if contact.bodyA.node == player || contact.bodyB.node == player {
			if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
				explosion.position = player.position
				addChild(explosion)
			}
			
			let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
			runAction(sound)
			
			gameOver.alpha = 1
			gameState = .Dead
			backgroundMusic.runAction(SKAction.stop())
			player.removeFromParent()
			speed = 0
		}
	}
	
	deinit {
		timer.invalidate()
	}
}

extension GameScene {
	private func createPlayer() {
		let playerTexture = SKTexture(imageNamed: "player-1")
		player = SKSpriteNode(texture: playerTexture)
		player.zPosition = 10
		player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
		
		addChild(player)
		
		player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
		player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
		player.physicsBody?.dynamic = false
		player.physicsBody?.collisionBitMask = 0
		
		let frame2 = SKTexture(imageNamed: "player-2")
		let frame3 = SKTexture(imageNamed: "player-3")
		let animation = SKAction.animateWithTextures([playerTexture, frame2, frame3, frame2], timePerFrame: 0.01)
		let runForever = SKAction.repeatActionForever(animation)
		
		player.runAction(runForever)
	}
	
	private func createSky() {
		let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
		topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
		
		let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.33))
		topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
		
		topSky.position = CGPoint(x: frame.midX, y: frame.height)
		bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height / 2)
		
		addChild(topSky)
		addChild(bottomSky)
		
		bottomSky.zPosition = -40
		topSky.zPosition = -40
	}
	
	private func createBackground() {
		let backgroundTexture = SKTexture(imageNamed: "background")
		
		for i in 0...1 {
			let background = SKSpriteNode(texture: backgroundTexture)
			background.zPosition = -30
			background.anchorPoint = CGPointZero
			background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 100)
			addChild(background)
			
			let moveLeft = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: 20)
			let moveReset = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0)
			let moveLoop = SKAction.sequence([moveLeft, moveReset])
			let moveForever = SKAction.repeatActionForever(moveLoop)
			
			background.runAction(moveForever)
		}
	}
	
	private func createGround() {
		let groundTexture = SKTexture(imageNamed: "ground")
		
		for i in 0...1 {
			let ground = SKSpriteNode(texture: groundTexture)
			ground.zPosition = -10
			ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
			
			ground.physicsBody = SKPhysicsBody(texture: groundTexture, size: groundTexture.size())
			ground.physicsBody?.dynamic = false
			
			addChild(ground)
			
			let moveLeft = SKAction.moveByX(-groundTexture.size().width, y: 0, duration: duration - 0.8)
			let moveReset = SKAction.moveByX(groundTexture.size().width, y: 0, duration: 0)
			let moveLoop = SKAction.sequence([moveLeft, moveReset])
			let moveForever = SKAction.repeatActionForever(moveLoop)
			
			ground.runAction(moveForever)
		}
	}
	
	private func createRocks() {
		let rockTexture = SKTexture(imageNamed: "rock")
		
		let topRock = SKSpriteNode(texture: rockTexture)
		topRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
		topRock.physicsBody?.dynamic = false
		topRock.zRotation = CGFloat(M_PI)
		topRock.xScale = -1.0
		
		let bottomRock = SKSpriteNode(texture: rockTexture)
		bottomRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
		bottomRock.physicsBody?.dynamic = false
		
		topRock.zPosition = -20
		bottomRock.zPosition = -20
		
		let rockCollision = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 32, height: frame.height))
		rockCollision.physicsBody = SKPhysicsBody(rectangleOfSize: rockCollision.size)
		rockCollision.physicsBody?.dynamic = false
		rockCollision.name = "scoreDetect"
		
		addChild(topRock)
		addChild(bottomRock)
		addChild(rockCollision)
		
		let xPosition = frame.width + topRock.frame.width
		
		let max = Int(frame.height / 3)
		let rand = GKRandomDistribution(lowestValue: -100, highestValue: max)
		let yPosition = CGFloat(rand.nextInt())
		
		//let rockDistance: CGFloat = 67
		
		topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.size.height + rockDistance)
		bottomRock.position = CGPoint(x: xPosition, y: yPosition - rockDistance)
		rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width
			 * 2), y: frame.midY)
		
		let endPosition = frame.width + (topRock.frame.width * 2)
		
		let moveAction = SKAction.moveByX(-endPosition, y: 0, duration: duration)
		let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
		topRock.runAction(moveSequence)
		bottomRock.runAction(moveSequence)
		rockCollision.runAction(moveSequence)
	}
	
	private func initRocks() {
		let create = SKAction.runBlock { [unowned self] in
			self.createRocks()
		}
		
		let wait = SKAction.waitForDuration(3)
		let sequence = SKAction.sequence([create, wait])
		let repeatForever = SKAction.repeatActionForever(sequence)
		
		runAction(repeatForever)
	}
	
	private func createScore() {
		scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
		scoreLabel.fontSize = 24
		
		scoreLabel.position = CGPoint(x: frame.maxX - 20, y: frame.maxY - 40)
		scoreLabel.horizontalAlignmentMode = .Right
		scoreLabel.text = "SCORE: 0"
		scoreLabel.fontColor = UIColor.blackColor()
		
		addChild(scoreLabel)
	}
	
	private func createLogos() {
		logo = SKSpriteNode(imageNamed: "logo")
		logo.position = CGPoint(x: frame.midX, y: frame.midY)
		addChild(logo)
		
		gameOver = SKSpriteNode(imageNamed: "gameOver")
		gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
		gameOver.alpha = 0
		addChild(gameOver)
	}
	
	func increaseDifficulty() {
		if rockDistance > 50 {
			rockDistance -= 0.5
		}
		
		if duration > 3 {
			duration -= 0.3
		}
	}
}
