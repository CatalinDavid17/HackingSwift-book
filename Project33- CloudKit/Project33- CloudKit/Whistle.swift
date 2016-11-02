//
//  Whistle.swift
//  Project33- CloudKit
//
//  Created by Catalin David on 14/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import CloudKit

class Whistle: NSObject {
	var recordID: CKRecordID!
	var genre: String!
	var comments: String!
	var audio: NSURL!
}
