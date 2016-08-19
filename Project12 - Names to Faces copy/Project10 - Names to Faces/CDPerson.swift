//
//  CDPeople.swift
//  Project10 - Names to Faces
//
//  Created by Catalin David on 18/08/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class CDPerson: NSObject, NSCoding {

	var name: String
	var image: String
	
	init(name: String, image: String) {
		
		self.name = name
		self.image = image
		
	}
	
	required init(coder aDecorder: NSCoder) {
		
		name = aDecorder.decodeObjectForKey("name")	as! String
		image = aDecorder.decodeObjectForKey("image") as! String
		
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		
		aCoder.encodeObject(name, forKey: "name")
		aCoder.encodeObject(image, forKey: "image")
		
	}
	
}
