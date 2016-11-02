//
//  ViewController.swift
//  project39-XCTesting
//
//  Created by Catalin David on 24/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit

enum Screen: Int {
	case text
	case square
	case circle
	case lines
	case rotate
	case rainbow
	case count
}

class ViewController: UITableViewController {
	var playData = PlayData()
	var screen = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(searchTapped))
		shakeView(self.view)
		screen = 0
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return playData.filteredWords.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
		
		let word = playData.filteredWords[indexPath.row]
		cell.textLabel!.text = word
		cell.detailTextLabel!.text = "\(playData.wordsCount.countForObject(word))"
		
		return cell
	}
	
	func searchTapped() {
		let ac = UIAlertController(title: "Filter...", message: nil, preferredStyle: .Alert)
		ac.addTextFieldWithConfigurationHandler(nil)
		
		ac.addAction(UIAlertAction(title: "Filter", style: .Default, handler: { [unowned self] _ in
			let userInput = ac.textFields?[0].text ?? "0"
			self.playData.applyUserFilter(userInput)
			self.tableView.reloadData()
			}))
		
		ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		
		presentViewController(ac, animated: true, completion: nil)
	}
	
	//MARK:- Testing methods
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "toTest" {
			if let vc = segue.destinationViewController as? TestController {
				switch screen {
    			case Screen.text.rawValue:
					vc.image = drawString()
				case Screen.circle.rawValue:
					vc.image = drawCircle()
				case Screen.square.rawValue:
					vc.image = drawRect()
				case Screen.lines.rawValue:
					vc.image = drawLines()
				case Screen.rotate.rawValue:
					vc.image = rotateContext()
				case Screen.rainbow.rawValue:
					vc.image = addRainbowToImage(UIImage(named: "one")!)
    			default:
					vc.image = drawString()
				}
			}
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if screen >= Screen.count.rawValue {
			screen = 0
		} else {
			screen = screen + 1
		}
	}
	//MARK: - Methods from tips
	
	func shakeView(vw: UIView) {
		let animation = CAKeyframeAnimation()
		animation.keyPath = "position.x"
		animation.values = [0, 10, -10, 10, -5, 5, -5, 0]
		animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
		animation.duration = 0.4
		animation.additive = true
		
		vw.layer.addAnimation(animation, forKey: "shake")
	}
	
	func shapeLayer(vw: UIView) {
		let layer = CAShapeLayer()
		layer.path = UIBezierPath(roundedRect: CGRect(x: 64, y: 64, width: 160, height: 160), cornerRadius: 50).CGPath
		layer.fillColor = UIColor.redColor().CGColor
		
		vw.layer.addSublayer(layer)
	}
	
	func createParticles() {
		let particleEmitter = CAEmitterLayer()
		
		particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: -96)
		particleEmitter.emitterShape = kCAEmitterLayerLine
		particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
		
		let red = makeEmitterCellWithColor(UIColor.redColor())
		let green = makeEmitterCellWithColor(UIColor.greenColor())
		let blue = makeEmitterCellWithColor(UIColor.blueColor())
		
		particleEmitter.emitterCells = [red, green, blue]
		
		view.layer.addSublayer(particleEmitter)
	}
	
	func makeEmitterCellWithColor(color: UIColor) -> CAEmitterCell {
		let cell = CAEmitterCell()
		cell.birthRate = 3
		cell.lifetime = 7.0
		cell.lifetimeRange = 0
		cell.color = color.CGColor
		cell.velocity = 200
		cell.velocityRange = 50
		cell.emissionLongitude = CGFloat(M_PI)
		cell.emissionRange = CGFloat(M_PI_4)
		cell.spin = 2
		cell.spinRange = 3
		cell.scaleRange = 0.5
		cell.scaleSpeed = -0.05
		
		cell.contents = UIImage(named:"particle")?.CGImage
		
		return cell
	}
	
	func makeShape() {
		let layer = CAShapeLayer()
		layer.path = UIBezierPath(roundedRect: CGRect(x: 64, y: 64, width: 160, height: 160), cornerRadius: 50).CGPath
		layer.fillColor = UIColor.redColor().CGColor
		view.layer.addSublayer(layer)
	}
	
	func CGPointManhattanDistance(from from: CGPoint, to: CGPoint) -> CGFloat {
		return (abs(from.x - to.x) + abs(from.y - to.y))
	}
	
	func CGPointDistanceSquared(from from: CGPoint, to: CGPoint) -> CGFloat {
		return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y);
	}
	
	func CGPointDistance(from from: CGPoint, to: CGPoint) -> CGFloat {
		return sqrt(CGPointDistanceSquared(from: from, to: to))
	}
	
	func drawCircle() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 0)
		let context = UIGraphicsGetCurrentContext()
		let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
		
		CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
		CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
		CGContextSetLineWidth(context, 10)
		
		CGContextAddEllipseInRect(context, rectangle)
		CGContextDrawPath(context, .FillStroke)
		
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return img
	}
	
	func drawRect() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 0)
		let context = UIGraphicsGetCurrentContext()
		let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
		
		CGContextSetFillColorWithColor(context, UIColor.lightGrayColor().CGColor)
		CGContextSetStrokeColorWithColor(context, UIColor.blueColor().CGColor)
		CGContextSetLineWidth(context, 10)
		
		CGContextAddRect(context, rectangle)
		CGContextDrawPath(context, .FillStroke)
		
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return img
	}
	
	func drawString() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 0)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .Center
		
		let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 36)!, NSParagraphStyleAttributeName: paragraphStyle]
		let string = "How much wood would a woodchuck\nchuck if a woodchuck would chuck wood?"
		string.drawWithRect(CGRect(x: 32, y: 32, width: 448, height: 448), options: .UsesLineFragmentOrigin, attributes: attrs, context: nil)
		
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return img
	}
	
	func drawLines() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 500, height: 500), false, 0)
		let context = UIGraphicsGetCurrentContext()
		
		CGContextMoveToPoint(context,50, 450)
		CGContextAddLineToPoint(context, 250, 50)
		CGContextAddLineToPoint(context, 450, 450)
		CGContextAddLineToPoint(context, 50, 450)
		
		CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
		CGContextStrokePath(context)
		
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return img
	}
	
	func rotateContext() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 0)
		let context = UIGraphicsGetCurrentContext()
		CGContextTranslateCTM(context, 256, 256)
		
		var first = true
		var length: CGFloat = 256
		
		for _ in 0..<256 {
			CGContextRotateCTM(context, CGFloat(M_PI_2))
			
			if first {
				CGContextMoveToPoint(context, length, 50)
				first = false
			} else {
				CGContextAddLineToPoint(context, length, 50)
			}
			length *= 0.99
		}
		
		CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
		CGContextStrokePath(context)
		
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return img
	}
	
	func rotationFromTransform(transform: CGAffineTransform) -> Double {
		return atan2(Double(transform.b), Double(transform.a))
	}
	
	func scaleFromTransform(transform: CGAffineTransform) -> Double {
		return sqrt(Double(transform.a * transform.a + transform.c * transform.c))
	}
	
	func translationFromTransform(transform: CGAffineTransform) -> CGPoint {
		return CGPointMake(transform.tx, transform.ty)
	}
	
	func drawPDFfromURL(url : NSURL) -> UIImage? {
		guard let document = CGPDFDocumentCreateWithURL(url) else {
			return nil
		}
		guard let page = CGPDFDocumentGetPage(document, 1) else {
			return nil
		}
		
		let pageRect = CGPDFPageGetBoxRect(page, .MediaBox)
		
		UIGraphicsBeginImageContextWithOptions(pageRect.size, true, 0)
		let context = UIGraphicsGetCurrentContext()
		
		CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
		CGContextFillRect(context, pageRect)
		
		CGContextTranslateCTM(context, 0.0, pageRect.size.height)
		CGContextScaleCTM(context, 1.0, -1.0)
		CGContextDrawPDFPage(context, page)
		
		let img = UIGraphicsGetImageFromCurrentImageContext()
		
		UIGraphicsEndImageContext()
		
		return img
	}
	
	func blendImages() -> UIImage {
		if let img = UIImage(named: "example"), img2 = UIImage(named: "example2") {
			let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
			
			UIGraphicsBeginImageContextWithOptions(img.size, true, 0)
			let context = UIGraphicsGetCurrentContext()
			
			CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
			CGContextFillRect(context, rect)
			
			img.drawInRect(rect, blendMode: .Normal, alpha: 1)
			img2.drawInRect(rect, blendMode: .Luminosity, alpha: 1)
			
			let result = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			return result
		}
		
		return UIImage()
	}
	
	func addRainbowToImage(img: UIImage) -> UIImage {
		let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
		
		let sectionHeight = img.size.height / 6
		
		let red = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 0.8).CGColor
		let orange = UIColor(red: 1, green: 0.7, blue: 0.35, alpha: 0.8).CGColor
		let yellow = UIColor(red: 1, green: 0.85, blue: 00.1, alpha: 0.65).CGColor
		let green = UIColor(red: 0, green: 0.7, blue: 0.2, alpha: 0.5).CGColor
		let blue = UIColor(red: 0, green: 0.35, blue: 0.7, alpha: 0.5).CGColor
		let purple = UIColor(red: 0.3, green: 0, blue: 0.5, alpha: 0.6).CGColor
		let colors = [red, orange, yellow, green, blue, purple]
		
		UIGraphicsBeginImageContextWithOptions(img.size, true, 0)
		let context = UIGraphicsGetCurrentContext()
		
		CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
		CGContextFillRect(context, rect)
		
		for i in 0..<6 {
			let color = colors[i]
			let rect = CGRect(x: 0, y: CGFloat(i) * sectionHeight, width: rect.width, height: sectionHeight)
			
			CGContextSetFillColorWithColor(context, color)
			CGContextFillRect(context, rect)
		}
		
		img.drawInRect(rect, blendMode: .Luminosity, alpha: 0.6)
		let img = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return img
	}
	
	func blendColor() {
		/* 
		firework.color = UIColor.cyanColor()
		firework.colorBlendFactor = 1
		let action = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1, duration: 1)
		*/
	}
	
	/*
	override func didMoveToView(view: SKView) {
		let music = SKAudioNode(fileNamed: "music.m4a")
		addChild(music)
	
		music.positional = true
		music.position = CGPoint(x: -1024, y:0)
		
		let moveForward = SKAction.moveToX(1024, duration: 2)
		let moveBack = SKAction.moveToX(-1024, duration: 2)
		let sequence = SKAction.sequence([moveForward, moveBack])
		let repeatForever = SKAction.repeatActionForever(sequence)
	
		music.runAction(repeatForever)
	}
	
	func drawShape() {
		let shape = SKShapeNode()
		shape.path = UIBezierPath(roundedRect: CGRect(x: -128, y: -128, width: 256, height: 256), cornerRadius: 64).CGPath
		shape.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
		shape.fillColor = UIColor.redColor()
		shape.strokeColor = UIColor.blueColor()
		shape.lineWidth = 10
		addChild(shape)
	
	*/
}

