//
//  ViewController.swift
//  Project31 - MultiBrowser
//
//  Created by Catalin David on 07/10/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
	
	@IBOutlet weak var addressbar: UITextField!
	@IBOutlet weak var stackView: UIStackView!
	
	weak var activeWebView: UIWebView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setDefaultTitle()
		
		let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addWebView))
		let delete = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(deleteWebView))
		navigationItem.rightBarButtonItems = [delete, add]
		
		self.addressbar.text = "https://"
	}
	
	func addWebView() {
		let webView = UIWebView()
		webView.delegate = self
		
		stackView.addArrangedSubview(webView)
		
		let url = NSURL(string: "https://www.hackingwithswift.com")!
		webView.loadRequest(NSURLRequest(URL: url))
		
		webView.layer.borderColor = UIColor.blueColor().CGColor
		selectWebView(webView)
		
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
		recognizer.delegate = self
		webView.addGestureRecognizer(recognizer)
	}
	
	func deleteWebView() {
		if let webView = activeWebView {
			if let index = stackView.arrangedSubviews.indexOf(webView) {
				stackView.removeArrangedSubview(webView)
				
				webView.removeFromSuperview()
				
				if stackView.arrangedSubviews.count == 0 {
					setDefaultTitle()
				} else {
					var currentIndex = Int(index)
					
					if currentIndex == stackView.arrangedSubviews.count {
						currentIndex = stackView.arrangedSubviews.count - 1
					}
					
					if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? UIWebView {
						selectWebView(newSelectedWebView)
					}
				}
			}
		}
	}
	
	func setDefaultTitle() {
		title = "Multibrowser"
		
	}
	
	func selectWebView(webView: UIWebView) {
		for view in stackView.arrangedSubviews {
			view.layer.borderWidth = 0
		}
		
		activeWebView = webView
		webView.layer.borderWidth = 3
		
		updateUIUsingWebBiew(webView)
	}
	
	func webViewTapped(recognizer: UITapGestureRecognizer) {
		if let selectedWebView = recognizer.view as? UIWebView {
			selectWebView(selectedWebView)
		}
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		if let webView = activeWebView, address = addressbar.text {
			if let url = NSURL(string: address) {
				webView.loadRequest(NSURLRequest(URL: url))
			}
		}
		
		textField.resignFirstResponder()
		return true
	}
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
		if traitCollection.horizontalSizeClass == .Compact {
			stackView.axis = .Vertical
		} else {
			stackView.axis = .Horizontal
		}
	}
	
	func updateUIUsingWebBiew(webView: UIWebView) {
		title = webView.stringByEvaluatingJavaScriptFromString("document.title")
		addressbar.text	= webView.request?.URL?.absoluteString ?? ""
	}
	
	func webViewDidFinishLoad(webView: UIWebView) {
		if webView == activeWebView {
			updateUIUsingWebBiew(webView)
		}
	}
}

