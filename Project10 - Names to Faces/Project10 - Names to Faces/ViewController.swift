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
	
	var people = [CDPerson]()
	
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
		
		let person = CDPerson(name: "Unknown", image: imageName)
		people.append(person)
		collectionView.reloadData()
		
		dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	//MARK: - UICollectionViewDataSource - UICollectionViewDelegate
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return people.count
		
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath
							 indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Person", forIndexPath: indexPath) as! CDPersonCell
		
		let person = people[indexPath.item]
		
		cell.name.text = person.name
		
		let path = getDocumentsDirectory().stringByAppendingPathComponent(person.image)
		cell.imageView.image = UIImage(contentsOfFile: path)
		
		cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
		cell.imageView.layer.borderWidth = 2
		cell.imageView.layer.cornerRadius = 3
		cell.layer.cornerRadius = 7
		
		return cell
		
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
		let person = people[indexPath.item]
		
		let alertController = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .Alert)
		alertController.addTextFieldWithConfigurationHandler(nil)
		
		alertController.addAction(UIAlertAction(title: "OK", style: .Default) {
			[unowned self, alertController] _ in
			let newName = alertController.textFields![0]
			person.name = newName.text!
			
			self.collectionView.reloadData()
		})
		
		presentViewController(alertController, animated: true, completion: nil)
		
	}
	
}

