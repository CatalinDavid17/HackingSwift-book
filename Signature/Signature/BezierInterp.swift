//
//  CachedView.swift
//  Signature
//
//  Created by Catalin David on 18/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class BezierInterp: UIView {
	var bezierPath: UIBezierPath!
	var image: UIImage?
	var pts: [CGPoint] = [CGPoint(), CGPoint(), CGPoint(), CGPoint()]
	var ctr: Int = 0
	
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
			ctr = 0
			pts[0] = touch.locationInView(self)
		}
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		
		ctr += 1
		pts[ctr] = touch.locationInView(self)
		
		if ctr == 3 {
			bezierPath.moveToPoint(pts[0])
			bezierPath.addCurveToPoint(pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
			self.setNeedsDisplay()
			pts[0] = bezierPath.currentPoint
			ctr = 0
		}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {	
		drawBitMap()
		self.setNeedsDisplay()
		pts[0] = bezierPath.currentPoint
		bezierPath.removeAllPoints()
		ctr = 0
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
