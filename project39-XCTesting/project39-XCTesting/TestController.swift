//
//  TestController.swift
//  project39-XCTesting
//
//  Created by Catalin David on 26/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class TestController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	
	var image: UIImage?
	
	override func viewDidLoad() {
		self.imageView.image = image
	}
}
