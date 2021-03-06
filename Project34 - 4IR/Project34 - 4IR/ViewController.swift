//
//  ViewController.swift
//  Project34 - 4IR
//
//  Created by Catalin David on 12/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

	@IBOutlet var columnButtons: [UIButton]!
	
	var placedChips = [[UIView]]()
	var board: Board!
	var strategist: GKMinmaxStrategist!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for _ in 0..<Board.width {
			placedChips.append([UIView]())
		}
		
		
		strategist = GKMinmaxStrategist()
		strategist.maxLookAheadDepth = 7
		strategist.randomSource = nil
		resetBoard()
	
	}

	@IBAction func makeMove(sender: UIButton) {
		let column = sender.tag
		
		if let row = board.nextEmptySlotInColumn(column) {
			board.addChip(board.currentPlayer.chip, inColumn: column)
			addChipAtColumn(column, row: row, color: board.currentPlayer.color)
			continueGame()
		}
	}
	
	func resetBoard() {
		board = Board()
		strategist.gameModel = board
		updateUI()
		
		for i in 0..<placedChips.count {
			for chip in placedChips[i] {
				chip.removeFromSuperview()
			}
			
			placedChips[i].removeAll(keepCapacity: true)
		}
	}

	func addChipAtColumn(column: Int, row: Int, color: UIColor) {
		let button = columnButtons[column]
		
		let size = min(button.frame.width, button.frame.height / 6)
		let rect = CGRect(x: 0, y: 0, width: size, height: size)
		
		if placedChips[column].count < row + 1 {
			let newChip = UIView()
			newChip.frame = rect
			newChip.userInteractionEnabled = false
			newChip.backgroundColor = color
			newChip.layer.cornerRadius = size / 2
			newChip.center = positionForChipAtColumn(column, row: row)
			newChip.transform = CGAffineTransformMakeTranslation(0, -800)
			view.addSubview(newChip)
			
			UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
				newChip.transform = CGAffineTransformIdentity
			}, completion: nil)
			
			placedChips[column].append(newChip)
		}
	}
	
	func positionForChipAtColumn(column: Int, row: Int) -> CGPoint {
		let button = columnButtons[column]
		let size = min(button.frame.width, button.frame.height / 6)
		
		let xOffsset = button.frame.midX
		var yOffset = button.frame.maxY - size / 2
		yOffset -= size * CGFloat(row)
		
		return CGPoint(x: xOffsset, y: yOffset)
	}
	
	func continueGame() {
		var gameOverTitle: String? = nil
		
		if board.isWinForPlayer2(board.currentPlayer) {
			gameOverTitle = "\(board.currentPlayer.name) Wins!"
		} else if board.isFull() {
			gameOverTitle = "Draw!"
		}
		
		if gameOverTitle != nil {
			let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .Alert)
			let alertAction = UIAlertAction(title: "Play again", style: .Default) { [unowned self] (action) in
				self.resetBoard()
			}
			
			alert.addAction(alertAction)
			presentViewController(alert, animated: true, completion: nil)
			
			return
		}
		
		board.currentPlayer = board.currentPlayer.opponent
		updateUI()
	}
	
	func updateUI() {
		title = "\(board.currentPlayer.name)'s Turn"
		
		if board.currentPlayer.chip == .Black {
			startAImove()
		}
	}
	
	//MARK:- AI Helper
	
	func columnForAIMove() -> Int? {
		if let aiMove = strategist.bestMoveForPlayer(board.currentPlayer) as? Move {
			return aiMove.column
		}
		
		return nil
	}
	
	func makeAImoveInColumn(column: Int) {
		columnButtons.forEach { $0.enabled = true }
		navigationItem.leftBarButtonItem = nil
		
		if let row = board.nextEmptySlotInColumn(column) {
			board.addChip(board.currentPlayer.chip, inColumn: column)
			addChipAtColumn(column, row: row, color: board.currentPlayer.color)
			
			continueGame()
		}
	}
	
	func startAImove() {
		columnButtons.forEach { $0.enabled = false }
		let spinner = UIActivityIndicatorView(activityIndicatorStyle: .White)
		spinner.startAnimating()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [unowned self] in
			let strategistTime = CFAbsoluteTimeGetCurrent()
			let column = self.columnForAIMove()!
			let delta = CFAbsoluteTimeGetCurrent() - strategistTime
			
			let aiTimeCeiling = 1.0
			let delay = min(aiTimeCeiling - delta, aiTimeCeiling)
			
			self.runAfterDelay(delay) {
				self.makeAImoveInColumn(column)
			}
		}
	}
	
	func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
		let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
		dispatch_after(time, dispatch_get_main_queue(), block)
	}

}
