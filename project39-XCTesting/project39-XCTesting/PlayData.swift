//
//  PlayData.swift
//  project39-XCTesting
//
//  Created by Catalin David on 24/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//
import Foundation

class PlayData {
	var allWords = [String]()
	var wordsCount: NSCountedSet!
	private(set) var filteredWords = [String]()
	
	init() {
		if let path = NSBundle.mainBundle().pathForResource("plays", ofType: "txt") {
			if let plays = try? String(contentsOfFile: path, usedEncoding: nil) {
				allWords = plays.componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
				allWords = allWords.filter { $0 != "" }
				
				wordsCount = NSCountedSet(array: allWords)
				let sorted = wordsCount.allObjects.sort { wordsCount.countForObject($0) > wordsCount.countForObject($1) }
				allWords = sorted as! [String]
			}
		}
		
		applyUserFilter("swift")
	}
	
	func applyUserFilter(input: String) {
		if let userNumber = Int(input) {
			applyFilter { self.wordsCount.countForObject($0) >= userNumber }
		} else {
			applyFilter { $0.rangeOfString(input, options: .CaseInsensitiveSearch) != nil }
		}
	}
	

	func applyFilter(filter: (String) -> Bool) {
		filteredWords = allWords.filter(filter)
	}
}
