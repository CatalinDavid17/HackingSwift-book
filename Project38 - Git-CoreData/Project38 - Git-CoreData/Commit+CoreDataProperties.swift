//
//  Commit+CoreDataProperties.swift
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

extension Commit {

    @NSManaged var date: NSDate
    @NSManaged var message: String
    @NSManaged var sha: String
    @NSManaged var url: String
    @NSManaged var author: Author

}
