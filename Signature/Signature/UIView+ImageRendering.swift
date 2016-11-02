//
//  UIView+ImageRendering.swift
//  Signature
//
//  Created by Catalin David on 18/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

extension UIView {
	func renderAsImage() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
		self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return img
	}
}