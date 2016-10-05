//
//  GradientView.swift
//  Project37 - Psychic Tester
//
//  Created by Catalin David on 05/10/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
	@IBInspectable var topColor: UIColor = UIColor.whiteColor()
	@IBInspectable var bottomCollor: UIColor = UIColor.blackColor()
	
	override class func layerClass() -> AnyClass {
		return CAGradientLayer.self
	}
	
	override func layoutSubviews() {
		(layer as! CAGradientLayer).colors = [topColor.CGColor, bottomCollor.CGColor]
	}
}
