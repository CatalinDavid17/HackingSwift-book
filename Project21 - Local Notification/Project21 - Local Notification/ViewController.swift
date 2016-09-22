//
//  ViewController.swift
//  Project21 - Local Notification
//
//  Created by Catalin David on 05/09/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func registerLocal(sender: AnyObject) {
		let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
		
		UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
	}

	@IBAction func scheduleLocal(sender: AnyObject) {
		guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else {
			return
		}
		
		if settings.types == .None {
			let ac = UIAlertController(title: "Can't schedule",
			                           message: "Either we don't have permission to schedule notifications, or we haven't asked yet",
			                           preferredStyle: .Alert)
			presentViewController(ac, animated: true, completion: nil)
			
			return
		}
		
		let notification = UILocalNotification()
		
		notification.fireDate = NSDate(timeIntervalSinceNow: 5)
		notification.alertBody = "Hey you! Yeah you! Swipe to Unlock"
		notification.alertAction = "be awesome"
		notification.soundName = UILocalNotificationDefaultSoundName
		notification.userInfo = ["CustomField1": "w00t"]
		
		UIApplication.sharedApplication().scheduleLocalNotification(notification)
	}
	
}
