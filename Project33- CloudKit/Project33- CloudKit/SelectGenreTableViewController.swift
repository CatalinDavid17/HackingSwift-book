//
//  SelectGenreTableViewController.swift
//  Project33- CloudKit
//
//  Created by Catalin David on 11/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class SelectGenreTableViewController: UITableViewController {

	static var genres = ["Unknown", "Blues", "Classical", "Electronic", "Jazz", "Metal", "Pop", "Reggae", "RnB", "Rock", "Soul"]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Select genre"
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Genre", style: .Plain, target: nil, action: nil)
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return SelectGenreTableViewController.genres.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
		cell.textLabel?.text = SelectGenreTableViewController.genres[indexPath.row]
		cell.accessoryType = .DisclosureIndicator
		
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let cell = tableView.cellForRowAtIndexPath(indexPath) {
			let genre = cell.textLabel?.text ?? SelectGenreTableViewController.genres[0]
			let vc = AddCommentsViewController()
			vc.genre = genre
			navigationController?.pushViewController(vc, animated: true)
		}
	}

	
}
