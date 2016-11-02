//
//  Signature.swift
//  Signature
//
//  Created by Catalin David on 18/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class Signature: UIView {
	var bezierPath: UIBezierPath!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.multipleTouchEnabled = false
		self.backgroundColor = UIColor.clearColor()
		bezierPath = UIBezierPath()
		bezierPath.lineWidth = 2
		bezierPath.lineJoinStyle = .Round
		bezierPath.lineCapStyle = .Round
		bezierPath.miterLimit = 1
		
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.multipleTouchEnabled = false
		bezierPath = UIBezierPath()
		bezierPath.lineWidth = 2
		self.backgroundColor = UIColor.clearColor()
		bezierPath.lineJoinStyle = .Round
		bezierPath.lineCapStyle = .Round
		bezierPath.miterLimit = 1

	}
	
	override func drawRect(rect: CGRect) {
		bezierPath.strokeWithBlendMode(.Luminosity, alpha: 1.0)
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
		self.touchesMoved(touches, withEvent: event)
	}
	
	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		guard let touches = touches else {
			return
		}
		
		self.touchesEnded(touches, withEvent: event)
	}

}
