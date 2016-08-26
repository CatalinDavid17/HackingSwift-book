//
//  ViewController.swift
//  Project 15 - Animation
//
//  Created by Catalin David on 26/08/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var imageView: UIImageView!
	var currentAnimation = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imageView = UIImageView(image: UIImage(named: "penguin"))
		imageView.center = CGPoint(x: 512, y: 384)
		view.addSubview(imageView)
	}

	@IBOutlet weak var tap: UIButton!
	
	@IBAction func tapped(sender: UIButton) {
		tap.hidden = true
		
		UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [],
		                           animations: { [unowned self] in
									
									switch self.currentAnimation {
									case 0:
										self.imageView.transform = CGAffineTransformMakeScale(2, 2)
									case 1:
										self.imageView.transform = CGAffineTransformIdentity
									case 2:
										self.imageView.transform = CGAffineTransformMakeTranslation(-256, -256)
									case 3:
										self.imageView.transform = CGAffineTransformIdentity
									case 4:
										self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
									case 5:
										self.imageView.transform = CGAffineTransformIdentity
									case 6:
										self.imageView.alpha = 0.1
										self.imageView.backgroundColor = UIColor.greenColor()
									case 7:
										self.imageView.alpha = 1
										self.imageView.backgroundColor = UIColor.clearColor()
									default:
										break
									}
		}) { [unowned self] (finished: Bool) in
			self.tap.hidden = false
		}
		
		currentAnimation = currentAnimation + 1
		
		if currentAnimation > 7 {
			currentAnimation = 0
		}
	}
	
}

