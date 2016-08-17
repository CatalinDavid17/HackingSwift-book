//
//  MasterViewController.swift
//  Project5-AnagramGame
//
//  Created by Catalin David on 17/08/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import GameplayKit

class MasterViewController: UITableViewController {

	var objects = [String]()
	var allWords = [String]()

	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add,
		                                                    target: self,
		                                                    action: #selector(promptForAnswer))
		
		if let startWordsPath = NSBundle.mainBundle().pathForResource("start", ofType: "txt") {
			if let startWords = try? String(contentsOfFile: startWordsPath, usedEncoding: nil) {
				allWords = startWords.componentsSeparatedByString("\n")
			}
		} else {
			allWords = ["silkworm"]
		}
		
	}
	
	//MARK: - Methods
	
	func startGame() {
		
		allWords = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(allWords) as! [String]
		title = allWords[0]
		objects.removeAll(keepCapacity: true)
		tableView.reloadData()
		
	}
	
	func wordIsPossible(word: String) -> Bool {
		
		var tempWord = title!.lowercaseString
		
		for letter in word.characters {
			if let pos = tempWord.rangeOfString(String(letter)) {
				tempWord.removeAtIndex(pos.startIndex)
			} else {
				return false
			}
		}
		return true
	
	}
	
	func wordIsOriginal(word: String) -> Bool {
		
		return !objects.contains(word)
		
	}
	
	func wordIsReal(word: String) -> Bool {
	
		let checker = UITextChecker()
		let range = NSMakeRange(0, word.characters.count)
		let misspelledRange = checker.rangeOfMisspelledWordInString(word, range: range,
		                                                            startingAt: 0, wrap: false,
		                                                            language: "en")
		
		return misspelledRange.location == NSNotFound
		
	}
	
	func submitAnswer(answer: String) {
		
		let lowerAnswer = answer.lowercaseString
		
		let errorTitle: String
		let errorMessage: String
		
		if wordIsPossible(lowerAnswer) {
			if wordIsOriginal(lowerAnswer) {
				if wordIsReal(lowerAnswer) {
					objects.insert(answer, atIndex: 0)
					
					let indexPath = NSIndexPath(forRow: 0, inSection: 0)
					tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
					
					return
				} else {
					errorTitle = "Word not recognised"
					errorMessage = "You can't just make them up, you know!"
				}
			} else {
				errorTitle = "Word used already"
				errorMessage = "Be more original!"
			}
		} else {
			errorTitle = "Word not possible"
			errorMessage = "You can't spell that word from '\(title!.lowercaseString)'!"
		}
		
		let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .Alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		presentViewController(alertController, animated: true, completion: nil)
		
	}

	func promptForAnswer() {
		
		let alertController = UIAlertController(title: "Enter answer",
		                                        message: nil,
		                                        preferredStyle: .Alert)
		
		alertController.addTextFieldWithConfigurationHandler(nil)
		
		let submitAction = UIAlertAction(title: "Submit",
		                                 style: .Default) {
											[unowned self, alertController] _ in
											
											let answer = alertController.textFields![0]
											self.submitAnswer(answer.text!)
											
										 }
			
			alertController.addAction(submitAction)
			
			presentViewController(alertController, animated: true, completion: nil)
		
	}
	
	// MARK: - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		
		return 1
		
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return objects.count
		
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

		let object = objects[indexPath.row]
		cell.textLabel!.text = object
		
		return cell
		
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		
		// Return false if you do not want the specified item to be editable.
		return true
		
	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,
	                        forRowAtIndexPath indexPath: NSIndexPath) {
		
		if editingStyle == .Delete {
		    objects.removeAtIndex(indexPath.row)
		    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		} else if editingStyle == .Insert {
		    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
		
	}


}

