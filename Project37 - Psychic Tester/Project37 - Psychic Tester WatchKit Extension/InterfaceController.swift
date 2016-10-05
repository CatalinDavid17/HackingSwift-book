//
//  InterfaceController.swift
//  Project37 - Psychic Tester WatchKit Extension
//
//  Created by Catalin David on 05/10/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import WatchConnectivity
import WatchKit
import Foundation

class InterfaceController: WKInterfaceController, WCSessionDelegate {
	@IBOutlet var hideButton: WKInterfaceButton!
	@IBOutlet var welcomeText: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
		
		if (WCSession.isSupported()) {
			let session = WCSession.defaultSession()
			session.delegate = self
			session.activateSession()
		}
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

	@IBAction func buttonTapped() {
		welcomeText.setHidden(true)
		hideButton.setHidden(true)
	}
	
	func  session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
		WKInterfaceDevice().playHaptic(.Click)
	}
}
