//
//  ActionViewController.swift
//  Extension
//
//  Created by Catalin David on 26/08/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
	var pageTitle = ""
	var pageURL = ""
	
	@IBOutlet weak var script: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let notificationCenter = NSNotificationCenter.defaultCenter()
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillChangeFrameNotification, object: nil)
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(done))
		
		if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
			if let itemProvider = inputItem.attachments?.first as? NSItemProvider {
				itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil) { [unowned self] (dict, error) in
					let itemDictionary = dict as! NSDictionary
					let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
				
					self.pageTitle = javaScriptValues["title"] as? String ?? "none"
					self.pageURL = javaScriptValues["URL"] as? String ?? "none"
				
					dispatch_async(dispatch_get_main_queue()) {
						self.title = self.pageTitle
					}
				}
			}
		}
    }

    @IBAction func done() {
        let item = NSExtensionItem()
		let webDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: ["customJavaScript": script.text]]
		let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
		item.attachments = [customJavaScript]
		
		extensionContext!.completeRequestReturningItems([item], completionHandler: nil)
    }
	
	func adjustForKeyboard(notification: NSNotification) {
		let userInfo = notification.userInfo!
		
		let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
		let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, toView: view.window)
		
		if notification.name == UIKeyboardWillHideNotification {
			script.contentInset = UIEdgeInsetsZero
		} else {
			script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
		}
		
		script.scrollIndicatorInsets = script.contentInset
		
		let selectedRange = script.selectedRange
		script.scrollRangeToVisible(selectedRange)
	}
}
