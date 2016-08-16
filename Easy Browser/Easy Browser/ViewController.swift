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
	var progressView: UIProgressView!
	var websites = ["apple.com", "hackingwithswift.com"]
	
	override func loadView() {
		
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
		
	}
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		let url = NSURL(string: "https://" + websites[0])!
		webView.loadRequest(NSURLRequest(URL: url))
		webView.allowsBackForwardNavigationGestures = true
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open",
		                                                    style: .Plain,
		                                                    target: self,
		                                                    action: #selector(openTapped))
		
		progressView = UIProgressView(progressViewStyle: .Default)
		progressView.sizeToFit()
		let progressButton = UIBarButtonItem(customView: progressView)
		
		let spacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
		                             target: nil,
		                             action: nil)
		let refresh = UIBarButtonItem(barButtonSystemItem: .Refresh,
		                              target: webView,
		                              action: #selector(webView.reload))
		
		toolbarItems = [progressButton, spacer, refresh]
		navigationController?.toolbarHidden = false
		
		webView.addObserver(self, forKeyPath: "estimatedProgress",
		                    options: .New,
		                    context: nil)
	}
	
	//MARK: - Action Methods
	
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
		for website in websites {
   			alertController.addAction(UIAlertAction(title: website,
													style: .Default,
													handler: openPage))
		}
		
		alertController.addAction(UIAlertAction(title: "Cancel",
												style: .Cancel,
												handler: nil ))
		
		presentViewController(alertController, animated: true, completion: nil)
		
	}
	
	//MARK: KVO - estimatedProgress
	
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?,
	                                     change: [String : AnyObject]?,
	                                     context: UnsafeMutablePointer<Void>) {
		
		if keyPath == "estimatedProgress" {
			progressView.progress = Float(webView.estimatedProgress)
		}
		
	}
	
	//MARK: WKNavigationDelegate
	
	func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction,
	             decisionHandler: (WKNavigationActionPolicy) -> Void) {
	
		let url = navigationAction.request.URL
		
		if let host = url!.host {
			for website in websites {
				if host.rangeOfString(website) != nil {
					decisionHandler(.Allow)
					return
				}
			}
		decisionHandler(.Cancel)
		}
	
	}

}