//
//  Capital.swift
//  Project19 - Capital Cities
//
//  Created by Catalin David on 01/09/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
	var title: String?
	var coordinate: CLLocationCoordinate2D
	var info: String
	
	init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
		self.title = title
		self.coordinate = coordinate
		self.info = info
	}
	
}
