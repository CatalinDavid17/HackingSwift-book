//
//  MasterViewController.swift
//  Project38 - Git-CoreData
//
//  Created by Catalin David on 18/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

	var detailViewController: DetailViewController? = nil
	var objects = [Commit]()
	var managedObjectContext: NSManagedObjectContext!
	let dateFormatISO8601 = "yyyy-MM-dd'T'HH:mm:ss'Z'"
	var commitPredicate: NSPredicate?
	var fetchedResultsController: NSFetchedResultsController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationItem.leftBarButtonItem = self.editButtonItem()

		if let split = self.splitViewController {
		    let controllers = split.viewControllers
		    self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		startCoreData()
		loadSavedData()
		performSelectorInBackground(#selector(fetchCommits), withObject: nil)
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .Plain, target: self, action: #selector(changeFilter))
	}

	override func viewWillAppear(animated: Bool) {
		self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
		super.viewWillAppear(animated)
	}

	// MARK: - Segues

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = self.tableView.indexPathForSelectedRow {
		        let object = fetchedResultsController.objectAtIndexPath(indexPath) as! Commit
		        let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
		        controller.detailItem = object
		        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
		        controller.navigationItem.leftItemsSupplementBackButton = true
		    }
		}
	}

	// MARK: - Table View

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return fetchedResultsController.sections?.count ?? 0
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = fetchedResultsController.sections![section]
		
		return sectionInfo.numberOfObjects
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

		let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Commit
		cell.textLabel!.text = object.message
		cell.detailTextLabel!.text = "By \(object.author.name) on \(object.date.description)"
		
		return cell
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		// Return false if you do not want the specified item to be editable.
		return true
	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
		   let commit = fetchedResultsController.objectAtIndexPath(indexPath) as! Commit
			managedObjectContext.deleteObject(commit)
			
			saveContext()
		} else if editingStyle == .Insert {
		    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}

	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return fetchedResultsController.sections![section].name
	}
	
	//MARK:- CoreData
	
	func startCoreData() {
		let modelURL = NSBundle.mainBundle().URLForResource("Project38", withExtension: "momd")!
		let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)!
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
		
		let url = getDocumentsDirectory().URLByAppendingPathComponent("Project38.sqlite")
		
		do {
			try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
			
			managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
			managedObjectContext.persistentStoreCoordinator = coordinator
			managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		} catch {
			print("Failed to initialize the application's saved data")
			return
		}
	}
	
	func saveContext() {
		if managedObjectContext.hasChanges {
			do {
				try managedObjectContext.save()
			} catch {
				print("An error occured while saving: \(error)")
			}
		}
	}
	
	func fetchCommits() {
		let newestCommitDate = getNewestCommitDate()
		
		if let data = NSData(contentsOfURL: NSURL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100&since=\(newestCommitDate)")!) {
			let jsonCommits = JSON(data: data)
			let jsonCommitArray = jsonCommits.arrayValue
			
			print("Received \(jsonCommitArray.count)new commits.")
			
			dispatch_async(dispatch_get_main_queue()) { [unowned self] in
				for jsonCommit in jsonCommitArray {
					if let commit = NSEntityDescription.insertNewObjectForEntityForName("Commit", inManagedObjectContext: self.managedObjectContext) as? Commit {
						self.configureCommit(commit, usingJSON: jsonCommit)
					}
				}
				
				self.saveContext()
				self.loadSavedData()
			}
		}
	}
	
	func loadSavedData() {
		if fetchedResultsController == nil {
			let fetch = NSFetchRequest(entityName: "Commit")
			let sort = NSSortDescriptor(key: "date", ascending: false)
			fetch.sortDescriptors = [sort]
			fetch.fetchBatchSize = 20
		
			fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: managedObjectContext, sectionNameKeyPath: "author.name", cacheName: nil)
			fetchedResultsController.delegate = self
		}
		
		fetchedResultsController.fetchRequest.predicate = commitPredicate
		
		do {
			try fetchedResultsController.performFetch()
			tableView.reloadData()
		} catch {
			print("Fetch failed")
		}
	}
	
	//MARK:- Helpers
	
	func getDocumentsDirectory() -> NSURL {
		let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		return urls[0]
	}
	
	func configureCommit(commit: Commit, usingJSON json: JSON) {
		commit.sha = json["sha"].stringValue
		commit.message = json["commit"]["message"].stringValue
		commit.url = json["html_url"].stringValue
		
		let formatter = NSDateFormatter()
		formatter.timeZone = NSTimeZone(name: "UTC")
		formatter.dateFormat = dateFormatISO8601
		commit.date = formatter.dateFromString(json["commit"]["commiter"]["date"].stringValue) ?? NSDate()
		
		var commitAuthor: Author!
		
		let authorFetchRequest = NSFetchRequest(entityName: "Author")
		authorFetchRequest.predicate = NSPredicate(format: "name == %@", json["commit"]["committer"]["name"].stringValue)
		
		if let authors = try? managedObjectContext.executeFetchRequest(authorFetchRequest) as! [Author] {
			if authors.count > 0 {
				commitAuthor = authors[0]
			}
		}
		
		if commitAuthor == nil {
			if let author = NSEntityDescription.insertNewObjectForEntityForName("Author", inManagedObjectContext: managedObjectContext) as? Author {
				author.name = json["commit"]["commiter"]["name"].stringValue
				author.email = json["commit"]["commiter"]["email"].stringValue
				commitAuthor = author
			}
		}
		
		commit.author = commitAuthor
	}
	
	func changeFilter() {
		let ac = UIAlertController(title: "Filter commits...", message: nil, preferredStyle: .ActionSheet)
		
		ac.addAction((UIAlertAction(title: "Show only fixes", style: .Default, handler: { [unowned self] _ in
			self.commitPredicate = NSPredicate(format: "message CONTAINS[c] 'fix'")
			self.loadSavedData()
		})))
		
		ac.addAction(UIAlertAction(title: "Ignore Pull Requests", style: .Default, handler: { [unowned self] _ in
			self.commitPredicate = NSPredicate(format: "NOT message BEGINSWITH 'Merge pull requests'")
			self.loadSavedData()
		}))
		
		ac.addAction(UIAlertAction(title: "Show only recent", style: .Default, handler: { [unowned self] _ in
			let twelveHoursAgo = NSDate().dateByAddingTimeInterval(-43200)
			self.commitPredicate = NSPredicate(format: "date > %@", twelveHoursAgo)
		}))
		
		ac.addAction(UIAlertAction(title: "Show all commits", style: .Default, handler: { [unowned self] _ in
			self.commitPredicate = nil
			self.loadSavedData()
		}))
		
		ac.addAction(UIAlertAction(title: "Show only Durian commits", style: .Default, handler: { [unowned self] _ in
			self.commitPredicate = NSPredicate(format: "author.name == 'Joe Groff'")
			self.loadSavedData()
		}))
		
		ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		presentViewController(ac, animated: true, completion: nil)
	}
	
	func getNewestCommitDate() -> String {
		let formatter = NSDateFormatter()
		formatter.timeZone = NSTimeZone(name: "UTC")
		formatter.dateFormat = dateFormatISO8601
		
		let newestCommitFetchRequest = NSFetchRequest(entityName: "Commit")
		let sort = NSSortDescriptor(key: "date", ascending: false)
		newestCommitFetchRequest.sortDescriptors = [sort]
		newestCommitFetchRequest.fetchLimit = 1
		
		if let commits = try? managedObjectContext.executeFetchRequest(newestCommitFetchRequest) as! [Commit] {
			if commits.count > 0 {
				return formatter.stringFromDate(commits[0].date.dateByAddingTimeInterval(1))
			}
		}
		
		return formatter.stringFromDate(NSDate(timeIntervalSince1970: 0))
	}
	
	//MARK:- FetchedResultsController
	
	func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
		switch type {
		case .Delete:
			tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
		default:
			break
		}
	}
}




