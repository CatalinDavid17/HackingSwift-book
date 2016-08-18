//
//  MasterViewController.swift
//  Project7-Feed
//
//  Created by Catalin David on 17/08/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

	var detailViewController: DetailViewController? = nil
	var objects = [[String: String]]()


	override func viewDidLoad() {
	
		super.viewDidLoad()
		
		let urlString: String
		
		if navigationController?.tabBarItem.tag == 0 {
			urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
		} else {
			urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
		}
		
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			[unowned self] in
			
			if let url = NSURL(string: urlString) {
				if let data = try? NSData(contentsOfURL: url, options: []) {
					let json = JSON(data: data)
					
					if json["metadata"]["responseInfo"]["status"].intValue == 200 {
						self.parseJSON(json)
					} else {
						self.showError()
					}
				} else {
					self.showError()
				}
			} else {
				self.showError()
			}
		}
		
	}

	override func viewWillAppear(animated: Bool) {
		self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
		super.viewWillAppear(animated)
	}
	
	//MARK: - Methods
	
	func parseJSON(json: JSON) {
		
		for result in json["results"].arrayValue {
			let title = result["title"].stringValue
			let body = result["body"].stringValue
			let signatures = result["signatureCount"].stringValue
			let object = ["title": title, "body": body, "signatures": signatures]
			
			objects.append(object)
		}
		
		dispatch_async(dispatch_get_main_queue()) {
			[unowned self] in
			
			self.tableView.reloadData()
		}
		
	}
	
	func showError() {
		
		dispatch_async(dispatch_get_main_queue()) {
			[unowned self] in
			
			let alertController = UIAlertController(title: "Loading error",
			                                        message: "There was a prooblem loadin the feed;" +
				"please check your connection and try agaon.",
			                                        preferredStyle: .Alert)
			
			alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			self.presentViewController(alertController, animated: true, completion: nil)
		}
		
	}
	
	// MARK: - Segues

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if segue.identifier == "showDetail" {
		    if let indexPath = self.tableView.indexPathForSelectedRow {
		        let object = objects[indexPath.row]
		        let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
		        controller.detailItem = object
		        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
		
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
		cell.textLabel!.text = object["title"]
		cell.detailTextLabel!.text = object["body"]
		
		return cell
		
	}

}

