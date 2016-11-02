//
//  ViewController.swift
//  Project33- CloudKit
//
//  Created by Catalin David on 10/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	static var dirty = true
	var tableView: UITableView!
	var whistles = [Whistle]()
	var newWhistles = [Whistle]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		title = "What's that Whistle?"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addWhistle))
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .Plain, target: nil, action: nil)
		
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Generes", style: .Plain, target: self, action: #selector(selectGenre))
	}
	
	override func loadView() {
		super.loadView()
		
		view.backgroundColor = UIColor.whiteColor()
		
		tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.dataSource = self
		tableView.delegate = self
		view.addSubview(tableView)
		
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: .AlignAllCenterX, metrics: nil, views: ["tableView": tableView]))
		
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[guide][tableView]|", options: .AlignAllCenterX, metrics: nil, views: ["guide": topLayoutGuide, "tableView": tableView]))
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if let indexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
		
		if ViewController.dirty {
			loadWhistles()
		}
	}
	
	func loadWhistles() {
		let pred = NSPredicate(value: true)
		let sort = NSSortDescriptor(key: "creationDate", ascending: false)
		let query = CKQuery(recordType: "WHistles", predicate: pred)
		query.sortDescriptors = [sort]
		
		let operation = CKQueryOperation(query: query)
		operation.desiredKeys = ["genre", "comments"]
		operation.resultsLimit = 50
		
		operation.recordFetchedBlock = { (record) in
			let whistle = Whistle()
			whistle.recordID = record.recordID
			whistle.genre = record["genre"] as! String
			whistle.comments = record["comments"] as! String
			self.newWhistles.append(whistle)
		}
		
		operation.queryCompletionBlock = { [unowned self] (cursor, error) in
			dispatch_async(dispatch_get_main_queue()) {
				if error == nil {
					ViewController.dirty = false
					self.whistles = self.newWhistles
					self.tableView.reloadData()
				} else {
					let ac = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of whistles; please try again: \(error!.localizedDescription)", preferredStyle: .Alert)
					ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
					self.presentViewController(ac, animated: true, completion: nil)
				}
			}
		}
		
		CKContainer.defaultContainer().publicCloudDatabase.addOperation(operation)
	}
	
	func makeAttributedString(title title: String, subtitle: String) -> NSAttributedString {
		let titleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody), NSForegroundColorAttributeName: UIColor.purpleColor()]
		let subtitleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)]
		
		let titleString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)
		
		if subtitle.characters.count > 0 {
			let subtitleString = NSAttributedString(string: "\n\(subtitle)", attributes: subtitleAttributes)
			titleString.appendAttributedString(subtitleString)
		}
		
		return titleString
	}
	
	func addWhistle() {
		let vc = RecordWhistleViewController()
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func selectGenre() {
		let vc = MyGenresViewController()
		navigationController?.pushViewController(vc, animated: true)
	}
	
	//MARK:- DataSource
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
		cell.accessoryType = .DisclosureIndicator
		cell.textLabel?.attributedText = makeAttributedString(title: whistles[indexPath.row].genre, subtitle: whistles[indexPath.row].comments)
		cell.textLabel?.numberOfLines = 0
		
		return cell
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.whistles.count
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let vc = ResultsViewController()
		vc.whistle = whistles[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}
}

