//
//  ViewController.swift
//  Project10 - Names to Faces
//
//  Created by Catalin David on 18/08/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
	
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add,
		                                                   target: self,
		                                                   action: #selector(addNewPerson))
		
	}
	
	//MARK: - Methods
	
	func addNewPerson() {
		
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		presentViewController(picker, animated: true, completion: nil)
		
	}
	
	func getDocumentsDirectory() -> NSString {
		
		let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
		let documentDirectory = paths[0]
		
		return documentDirectory
		
	}
	
	//MARK: - UiPickerControllerDelegate
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		
		dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		
		var newImage: UIImage
		
		if let possibleImage = info[UIImagePickerControllerEditedImage]	as? UIImage {
			newImage = possibleImage
		} else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			newImage = possibleImage
		} else {
			print("We cannot find an image!")
			return
		}
		
		let imageName = NSUUID().UUIDString
		let imagePath = getDocumentsDirectory().stringByAppendingPathComponent(imageName)
		
		if let jpegData = UIImageJPEGRepresentation(newImage, 80) {
			jpegData.writeToFile(imagePath, atomically: true)
		}
		
		dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	//MARK: - UICollectionViewDataSource - UICollectionViewDelegate
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return 10
		
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Person", forIndexPath: indexPath) as! CDPersonCell
		
		return cell
		
	}
	
}

