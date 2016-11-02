//
//  CachedView.swift
//  Signature
//
//  Created by Catalin David on 18/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class SmoothedView: UIView {
	var bezierPath: UIBezierPath!
	var image: UIImage?
	var points: [CGPoint] = [CGPoint(), CGPoint(), CGPoint(), CGPoint(), CGPoint()] // to keep track of the four points of our Bezier segment
	var pointIndex: Int = 0 // a counter variable to keep track of the point index
	var strokeColor = UIColor.blackColor()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		self.multipleTouchEnabled = false
		//self.backgroundColor = UIColor.whiteColor()
		bezierPath = UIBezierPath()
		bezierPath.lineWidth = 1
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.multipleTouchEnabled = false
		bezierPath = UIBezierPath()
		bezierPath.lineWidth = 1
		//self.backgroundColor = UIColor.whiteColor()
	}
	
	override func drawRect(rect: CGRect) {
		guard let image = image else {
			return
		}
		
		image.drawInRect(rect)
		strokeColor.setStroke()
		bezierPath.stroke()
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if let touch = touches.first {
			pointIndex = 0
			points[0] = touch.locationInView(self)
		}
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		
		pointIndex += 1
		points[pointIndex] = touch.locationInView(self)
		
		if pointIndex == 4 {
			/* move the endpoint to the middle of the line joining the
			second control point of the first Bezier segment
			and the first control point of the second Bezier segment */
			points[3] = CGPointMake((points[2].x + points[4].x)/2.0, (points[2].y + points[4].y)/2.0)
			
			bezierPath.moveToPoint(points[0])
			// add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
			bezierPath.addCurveToPoint(points[3], controlPoint1: points[1], controlPoint2: points[2])
			
			self.setNeedsDisplay()
			
			// replace points and get ready to handle the next segment
			points[0] = points[3]
			points[1] = points[4]
			pointIndex = 1
		}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		drawBitMap()
		self.setNeedsDisplay()
		bezierPath.removeAllPoints()
		pointIndex = 0
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
		strokeColor.setStroke()
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
