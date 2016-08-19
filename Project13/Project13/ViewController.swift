//
//  ViewController.swift
//  Project13
//
//  Created by Catalin David on 19/08/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var intensity: UISlider!
	
	var currentImage: UIImage!
	
	var context: CIContext!
	var currentFilter: CIFilter!
	
	override func viewDidLoad() {
	
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		title = "YACIFP"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add,
		                                                    target: self,
		                                                    action: #selector(importPicture))
		
		context = CIContext(options: nil)
		currentFilter = CIFilter(name: "CISepiaTone")
		
	}

	//MARK: Helper methods
	
	func importPicture() {
		
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		
		presentViewController(picker, animated: true, completion: nil)
		
	}
	
	func applyProcessing() {
		
		let inputKeys = currentFilter.inputKeys
		
		if inputKeys.contains(kCIInputIntensityKey) {
			currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
		}
		if inputKeys.contains(kCIInputRadiusKey) {
			currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
		}
		if inputKeys.contains(kCIInputScaleKey) {
			currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
		}
		if inputKeys.contains(kCIInputCenterKey) {
			currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2),
			                       forKey: kCIInputCenterKey)
		}
		
		let cgImage = context.createCGImage(currentFilter.outputImage!,
		                                    fromRect: currentFilter.outputImage!.extent)
		let processedImage = UIImage(CGImage: cgImage)
		imageView.image = processedImage
		
	}
	
	func setFilter(action: UIAlertAction!) {
		
		currentFilter = CIFilter(name: action.title!)
		
		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		
		applyProcessing()
		
	}
	
	func image(image: UIImage, didFinishSavingWithError error: NSError?,
	           contextInfo: UnsafePointer<Void>) {
	
		if error == nil {
			let alertController = UIAlertController(title: "Saved!",
			                                        message: "Your altered image has been saved to you photos.",
			                                        preferredStyle: .Alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			presentViewController(alertController, animated: true, completion: nil)
		} else {
			let alertController = UIAlertController(title: "Save error",
			                                        message: error?.localizedDescription,
			                                        preferredStyle: .Alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			presentViewController(alertController, animated: true, completion: nil)
		}
		
	}
	
	//MARK: Methods for action buttons
	
	@IBAction func changeFilter(sender: UIButton) {
		
		let alertController = UIAlertController(title: "Choose Filter",
		                                        message: nil,
		                                        preferredStyle: .ActionSheet)
		alertController.addAction(UIAlertAction(title: "CIBumpDistortion", style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: "CIGaussianBlur", style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: "CIPixellate", style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: "CISepiaTone", style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: "CITwirlDistortion", style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: "CIUnsharpMask", style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: "CIVignette", style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
		presentViewController(alertController, animated: true, completion: nil)
	
	}

	@IBAction func save(sender: UIButton) {
		
		UIImageWriteToSavedPhotosAlbum(imageView.image!, self,
		                               #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
		
	}
	
	@IBAction func intensityChanged(sender: UISlider) {
		
		applyProcessing()
		
	}
	
}

//MARK: Extension - UIImagePickerControllerDelegate

extension ViewController {
	
	func imagePickerController(picker: UIImagePickerController,
	                           didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		
		var newImage: UIImage
		
		if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
			newImage = possibleImage
		} else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			newImage = possibleImage
		} else {
			return
		}
		
		dismissViewControllerAnimated(true, completion: nil)
		
		currentImage = newImage
		
		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		applyProcessing()
		
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		
		dismissViewControllerAnimated(true, completion: nil)
		
	}
	
}