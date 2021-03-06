//
//  Author+CoreDataProperties.swift
//  Project38 - Git-CoreData
//
//  Created by Catalin David on 19/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Author {

    @NSManaged var email: String
    @NSManaged var name: String
    @NSManaged var commits: NSSet

}
