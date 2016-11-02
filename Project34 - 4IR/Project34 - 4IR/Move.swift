//
//  Move.swift
//  Project34 - 4IR
//
//  Created by Catalin David on 13/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
	var value: Int = 0
	var column: Int
	
	init(column: Int) {
		self.column = column
	}
	
}
