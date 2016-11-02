//
//  RecordWhistleViewController.swift
//  Project33- CloudKit
//
//  Created by Catalin David on 10/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import AVFoundation

class RecordWhistleViewController: UIViewController, AVAudioRecorderDelegate {
	
	var stackView: UIStackView!
	var recordButton: UIButton!
	
	var recordingSession: AVAudioSession!
	var whistleRecorder: AVAudioRecorder!
	
	var playButton: UIButton!
	var whistlePlayer: AVAudioPlayer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Record your whistle"
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .Plain, target: nil, action: nil)
		recordingSession = AVAudioSession.sharedInstance()
		
		do {
			try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
			try recordingSession.setActive(true)
			recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
				dispatch_async(dispatch_get_main_queue()) {
					if allowed {
						self.loadRecordingUI()
					} else {
						self.loadFailUI()
					}
				}
			}
		} catch {
			self.loadFailUI()
		}
	}
	
	override func loadView() {
		super.loadView()
		
		view.backgroundColor = UIColor.grayColor()
		
		stackView = UIStackView()
		stackView.spacing = 30
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = UIStackViewDistribution.FillEqually
		stackView.alignment = UIStackViewAlignment.Center
		stackView.axis = .Vertical
		view.addSubview(stackView)
		
		view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[stackView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["stackView": stackView]))
		view.addConstraint(NSLayoutConstraint(item: stackView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
	}
	
	//MARK: - UI Config
	func loadRecordingUI() {
		recordButton = UIButton()
		recordButton.translatesAutoresizingMaskIntoConstraints = false
		recordButton.setTitle("Tap to record", forState: .Normal)
		recordButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
		recordButton.addTarget(self, action: #selector(recordTapped), forControlEvents: .TouchUpInside)
		stackView.addArrangedSubview(recordButton)
		
		playButton = UIButton()
		playButton.translatesAutoresizingMaskIntoConstraints = false
		playButton.setTitle("Tap to play", forState: .Normal)
		playButton.hidden = true
		playButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
		playButton.addTarget(self, action: #selector(playTapped), forControlEvents: .TouchUpInside)
		stackView.addArrangedSubview(playButton)
	}
	
	func loadFailUI() {
		let failLabel = UILabel()
		failLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
		failLabel.text = "Recording failed: please ensure the app has access to your microphone."
		failLabel.numberOfLines = 0
		
		stackView.addArrangedSubview(failLabel)
	}
	
	//MARK: - Path config - class methods
	class func getDocumentsDirectory() -> NSString {
		let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
		let documentsDirectory = paths[0]
		
		return documentsDirectory
	}
	
	class func getWhistleURL() -> NSURL {
		let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("whistle.m4a")
		let audioURL = NSURL(fileURLWithPath: audioFilename)
		
		return audioURL
	}
	
	//MARK:- Recording methods
	func recordTapped() {
		if whistleRecorder == nil {
			startRecording()
			if !playButton.hidden {
				UIView.animateWithDuration(0.35) { [unowned self] in
					self.playButton.hidden = true
					self.playButton.alpha = 0
				}
			}
		} else {
			finishRecording(success: true)
		}
	}
	
	func nextTapped() {
		let vc = SelectGenreTableViewController()
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func playTapped() {
		let audioUrl = RecordWhistleViewController.getWhistleURL()
		
		do {
			whistlePlayer = try AVAudioPlayer(contentsOfURL: audioUrl)
			whistlePlayer.play()
		} catch {
			let ac = UIAlertController(title: "Playback failed", message: "There was a problem playing your whistle; please try re-recording.", preferredStyle: .Alert)
			ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			presentViewController(ac, animated: true, completion: nil)
		}
	}
	
	func startRecording() {
		view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
		
		recordButton.setTitle("Tap to stop", forState: .Normal)
		
		let audioURL = RecordWhistleViewController.getWhistleURL()
		print(audioURL.absoluteString)
		
		let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000.0,
		                AVNumberOfChannelsKey: 1 as NSNumber, AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue]
		
		do {
			whistleRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
			whistleRecorder.delegate = self
			whistleRecorder.record()
		} catch {
			finishRecording(success: false)
		}
	}
	
	func finishRecording(success success: Bool) {
		view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
		
		whistleRecorder.stop()
		whistleRecorder = nil
		
		if success {
			recordButton.setTitle("Tap to Record", forState: .Normal)
			if playButton.hidden {
				UIView.animateWithDuration(0.35) { [unowned self] in
					self.playButton.hidden = false
					self.playButton.alpha = 1
				}
			}
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(nextTapped))
		} else {
			recordButton.setTitle("Tap to Record", forState: .Normal)
			
			let ac = UIAlertController(title: "OK", message: "There was a problem recording your whistle, please try again", preferredStyle: .Alert)
			ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
			presentViewController(ac, animated: true, completion: nil)
		}
	}
	
}

//MARK: AVAudioRecorderDelegate
extension RecordWhistleViewController {
	func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
		if !flag {
			finishRecording(success: false)
		}
	}
}
