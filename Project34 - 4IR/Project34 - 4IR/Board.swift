//
//  Board.swift
//  Project34 - 4IR
//
//  Created by Catalin David on 12/10/2016.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import GameplayKit

enum ChipColor: Int {
	case None = 0
	case Red
	case Black
}

class Board: NSObject {
	static var width = 7
	static var height = 6
	
	var slots = [ChipColor]()
	var currentPlayer: Player
	var players: [GKGameModelPlayer]? {
		return Player.allPlayers
	}
	var activePlayer: GKGameModelPlayer? {
		return currentPlayer
	}
	
	override init() {
		for _ in 0..<Board.width * Board.height {
			slots.append(.None)
		}
		
		currentPlayer = Player.allPlayers[0]
		
		super.init()
	}
	
	func chipInColumn(column: Int, row: Int) -> ChipColor {
		return slots[row + column * Board.height]
	}
	
	func setChip(chip: ChipColor, inColumn column: NSInteger, row: NSInteger) {
		slots[row + column * Board.height] = chip
	}
	
	func nextEmptySlotInColumn(column: Int) -> Int? {
		for row in 0..<Board.height {
			if chipInColumn(column, row: row) == .None {
				return row
			}
		}
		
		return nil
	}
	
	func canMoveInColumn(column: Int) -> Bool {
		return nextEmptySlotInColumn(column) != nil
	}
	
	func addChip(chip: ChipColor, inColumn column: Int) {
		if let row = nextEmptySlotInColumn(column) {
			setChip(chip, inColumn: column, row: row)
		}
	}
	
	func isFull() -> Bool {
		for column in 0..<Board.width {
			if canMoveInColumn(column) {
				return false
			}
		}
		
		return true
	}
	
	func isWinForPlayer2(player: Player) -> Bool {
		let chip = player.chip
		
		for row in 0..<Board.height {
			for col in 0..<Board.width {
				if squaresMatchChip(chip, row: row, col: col, moveX: 1, moveY: 0) {
					return true
				} else if squaresMatchChip(chip, row: row, col: col, moveX: 0, moveY: 1) {
					return true
				} else if squaresMatchChip(chip, row: row, col: col, moveX: 1, moveY: 1) {
					return true
				} else if squaresMatchChip(chip, row: row, col: col, moveX: 1, moveY: -1) {
					return true
				}
			}
		}
		
		return false
	}
	
	func squaresMatchChip(chip: ChipColor, row: Int, col: Int, moveX: Int, moveY: Int) -> Bool {
		if row + (moveY * 3) < 0 { return false }
		if row + (moveY * 3) >= Board.height { return false }
		if col + (moveX * 3) < 0 { return false	}
		if col + (moveX * 3) >= Board.width { return false }
		
		if chipInColumn(col + moveX, row: row + moveY) != chip { return false }
		if chipInColumn(col + (moveX * 2), row: row + (moveY * 2)) != chip { return false }
		if chipInColumn(col + (moveX * 3), row: row + (moveY * 3)) != chip { return false }
			
		return true
	}
	
}

//MARK:- GKGameModel
extension Board: GKGameModel {
	func copyWithZone(zone: NSZone) -> AnyObject {
		let copy = Board()
		copy.setGameModel(self)
		
		return copy
	}
	
	func setGameModel(gameModel: GKGameModel) {
		if let board = gameModel as? Board {
			slots = board.slots
			currentPlayer = board.currentPlayer
		}
	}
	
	func gameModelUpdatesForPlayer(player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
		if let playerObject = player as? Player {
			if isWinForPlayer2(playerObject) || isWinForPlayer2(playerObject.opponent) {
				return nil
			}
			
			var moves = [Move]()
			
			for column in 0..<Board.width {
				if canMoveInColumn(column) {
					moves.append(Move(column: column))
				}
			}
			
			return moves
		}
		
		return nil
	}
	
	func applyGameModelUpdate(gameModelUpdate: GKGameModelUpdate) {
		if let move = gameModelUpdate as? Move {
			addChip(currentPlayer.chip, inColumn: move.column)
			currentPlayer = currentPlayer.opponent
		}
	}
	
	func scoreForPlayer(player: GKGameModelPlayer) -> Int {
		if let playerObject = player as? Player {
			if isWinForPlayer2(playerObject) {
				return 1000
			} else if isWinForPlayer2(playerObject.opponent) {
				return -1000
			}
		}
		
		return 0
	}
	
}
