//
//  BuildingNode.swift
//  Project29 - Exploding Monkeys
//
//  Created by Catalin David on 28/09/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class BuildingNode: SKSpriteNode {
	var currentImage: UIImage!
	
	func setup() {
		name = "building"
		
		currentImage = drawBuilding(size: size)
		texture = SKTexture(image: currentImage)
		
		configurePhysics()
	}
	
	func configurePhysics() {
		physicsBody = SKPhysicsBody(texture: texture!, size: size)
		physicsBody!.isDynamic = false
		physicsBody!.categoryBitMask = CollisionTypes.Banana.rawValue
	}
	
	func drawBuilding(size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		let context = UIGraphicsGetCurrentContext()
		
		let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		var color: UIColor
		
		switch GKRandomSource.sharedRandom().nextInt(upperBound: 3) {
		case 0:
			color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
		case 1:
			color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
		default:
			color = UIColor(hue: 00, saturation: 0, brightness: 0.67, alpha: 1)
		}
		
		context?.setFillColor(color.cgColor)
		context?.addRect(rectangle)
		context?.drawPath(using: .fill)
		
		let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
		let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
		
		for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
			for col in stride(from: 10, to: Int(size.width - 10), by: 40) {
				if RandomInt(min: 0, max: 1) == 0 {
					context?.setFillColor(lightOnColor.cgColor)
				} else {
					context?.setFillColor(lightOffColor.cgColor)
				}
				
				context?.fill(CGRect(x: col, y: row, width: 15, height: 20))
			}
		}
		
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return img!
	}
	
}
