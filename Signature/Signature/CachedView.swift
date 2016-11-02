//
//  CachedView.swift
//  Signature
//
//  Created by Catalin David on 18/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class CachedView: UIView {
	var bezierPath: UIBezierPath!
	var image: UIImage?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.multipleTouchEnabled = false
		self.backgroundColor = UIColor.whiteColor()
		bezierPath = UIBezierPath()
		bezierPath.lineWidth = 2
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.multipleTouchEnabled = false
		bezierPath = UIBezierPath()
		bezierPath.lineWidth = 2
		self.backgroundColor = UIColor.whiteColor()
	}
	
	override func drawRect(rect: CGRect) {
		guard let image = image else {
			return
		}
		image.drawInRect(rect)
		bezierPath.stroke()
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let touch = touches.first {
			bezierPath.moveToPoint(touch.locationInView(self))
		}
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		
		bezierPath.addLineToPoint(touch.locationInView(self))
		self.setNeedsDisplay()
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		
		bezierPath.addLineToPoint(touch.locationInView(self))
		drawBitMap()
		self.setNeedsDisplay()
		bezierPath.removeAllPoints()
	}
	
	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		guard let touches = touches else {
			return
		}
		
		self.touchesEnded(touches, withEvent: event)
	}
	
	func drawBitMap() {
		guard let image = image else {
			return
		}
		
		UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
		UIColor.blackColor().setStroke()
		bezierPath.stroke()
		
		UIColor.whiteColor().setFill()
		let rectPath = UIBezierPath(rect: self.bounds)
		rectPath.fill()
		
		image.drawAtPoint(CGPointZero)
		bezierPath.stroke()
		self.image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
	}
}
