//
//  DetailViewController.swift
//  Project38 - Git-CoreData
//
//  Created by Catalin David on 18/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var detailDescriptionLabel: UILabel!


	var detailItem: Commit? {
		didSet {
		    // Update the view.
		    self.configureView()
		}
	}

	func configureView() {
		// Update the user interface for the detail item.
		if let detail = self.detailItem {
		    if let label = self.detailDescriptionLabel {
		        label.text = detail.message
				navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Commit 1/\(detail.author.commits.count)", style: .Plain, target: self, action: #selector(showAuthorCommits))
		    }
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.configureView()
	}

	func showAuthorCommits() {
		
	}
}

