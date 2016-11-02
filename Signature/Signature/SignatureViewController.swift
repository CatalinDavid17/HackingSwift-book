//
//  ViewController.swift
//  Signature
//
//  Created by Catalin David on 18/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class SignatureViewController: UIViewController {
	var activeSlicePoints = [CGPoint]()
	var path = UIBezierPath()
	var paths = [UIBezierPath()]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		if let smoothedView = self.view as? SmoothedView {
			smoothedView.image = self.view.renderAsImage()
		}
	}
	
}

