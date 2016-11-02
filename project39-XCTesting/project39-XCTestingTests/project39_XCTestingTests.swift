//
//  project39_XCTestingTests.swift
//  project39-XCTestingTests
//
//  Created by Catalin David on 24/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import XCTest
@testable import project39_XCTesting

class project39_XCTestingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testAllWordsLoaded() {
		let playData = PlayData()
		XCTAssertEqual(playData.allWords.count, 18440, "allWords was not 18440")
	}
	
	func testWordCountsAreCorrect() {
		let playData = PlayData()
		XCTAssertEqual(playData.wordsCount.countForObject("home"), 174, "Home does not appear 174 times")
		XCTAssertEqual(playData.wordsCount.countForObject("fun"), 4, "Fun does not appear 174 times")
		XCTAssertEqual(playData.wordsCount.countForObject("mortal"), 41, "Mortal does not appear 174 times")
	}
	
	func testWordsLoadQuickly() {
		measureBlock() {
			_ = PlayData()
		}
	}
	
	func testUserFilterWorks() {
		let playData = PlayData()
		
		playData.applyUserFilter("100")
		XCTAssertEqual(playData.filteredWords.count, 495)
		
		playData.applyUserFilter("1000")
		XCTAssertEqual(playData.filteredWords.count, 55)
		
		playData.applyUserFilter("10000")
		XCTAssertEqual(playData.filteredWords.count, 1)
		
		playData.applyUserFilter("test")
		XCTAssertEqual(playData.filteredWords.count, 56)
		
		playData.applyUserFilter("swift")
		XCTAssertEqual(playData.filteredWords.count, 7)
		
		playData.applyUserFilter("objective-c")
		XCTAssertEqual(playData.filteredWords.count, 0)
	}
}
