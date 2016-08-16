//
//  ViewController.swift
//  Easy Browser
//
//  Created by Catalin David on 16/08/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

	var webView: WKWebView!
	
	override func loadView() {
		
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
		
	}
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		let url = NSURL(string: "https://www.hackingwithswift.com")!
		webView.loadRequest(NSURLRequest(URL: url))
		webView.allowsBackForwardNavigationGestures = true
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open",
		                                                    style: .Plain,
		                                                    target: self,
		                                                    action: #selector(openTapped))
		
		let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
		                             target: nil,
		                             action: nil)
		let refresh = UIBarButtonItem(barButtonSystemItem: .Refresh,
		                              target: webView,
		                              action: #selector(webView.reload))
		
		toolbarItems = [spacer, refresh]
		navigationController?.toolbarHidden = false
		
	}
	
	func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
		
		title = webView.title
		
	}
	
	func openPage(action: UIAlertAction!) {
	
		let url = NSURL(string: "https://" + action.title!)!
		webView.loadRequest(NSURLRequest(URL: url))
		
	}
	
	func openTapped() {
	
		let alertController = UIAlertController(title: "Open page...",
		                                        message: nil,
		                                        preferredStyle: .ActionSheet)
		alertController.addAction(UIAlertAction(title: "hackingwithswift.com",
												style: .Default,
												handler: openPage))
		alertController.addAction(UIAlertAction(title: "apple.com",
												style: .Default,
												handler: openPage))
		alertController.addAction(UIAlertAction(title: "Cancel",
												style: .Cancel,
												handler: nil ))
		
		presentViewController(alertController, animated: true, completion: nil)
		
	}
	
	
	
}

