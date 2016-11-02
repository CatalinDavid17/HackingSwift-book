//
//  Commit.swift
//  Project38 - Git-CoreData
//
//  Created by Catalin David on 19/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import Foundation
import CoreData


class Commit: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

	override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
		super.init(entity: entity, insertIntoManagedObjectContext: context)
		print("Init called")
	}
}
