//
//  SudokuPuzzle.swift
//  Sudoku
//
//  Created by Kelly Keniston on 3/7/17.
//  Copyright © 2017 Kelly Keniston. All rights reserved.
//

import UIKit

class SudokuPuzzle : NSObject {
    
    class SudokuTile : NSObject {
        
        var pencilNums : [[Int]]!
        var fixed : Bool!
        var num : Int!
        
        init(iNum : Int, iFixed : Bool) {
            super.init()
            self.num = iNum
            self.fixed = iFixed
            self.pencilNums = [[Int]](repeating: [Int](repeating: 0, count: 3), count: 3)
            for i in 0...2 {
                for j in 0...2 {
                    self.pencilNums[i][j] = 0
                }
            }
        }
        
        func getNum() -> Int { return self.num }
        func getFixed() -> Bool { return self.fixed }
        func getPencilNums() -> [[Int]] { return self.pencilNums }
        func setNum(n : Int) { self.num = n }
        func setFixed() { self.fixed = true }
        func setUnFixed() { self.fixed = false }
        func setPencilNum(row: Int, col: Int) { self.pencilNums[row][col] = 1 }
        func clearPencilNum(row: Int, col: Int) { self.pencilNums[row][col] = 0 }
    }
    
    var size : Int!
    var simplePuzzles : [String]!
    var hardPuzzles : [String]!
    var gameBoard : [[SudokuTile]]!
    
    override init() {
        super.init()
        self.size = 0
        self.simplePuzzles = getPuzzles(name: "simple")
        self.hardPuzzles = getPuzzles(name: "hard")
        self.gameBoard = [[SudokuTile]]()
        
        for _ in 0...8 {
            var colArray = [SudokuTile]()
            for _ in 0...8 {
                colArray.append(SudokuTile(iNum: 0, iFixed: false))
            }
            self.gameBoard.append(colArray)
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(simplePuzzles.count)))
        //NSLog(simplePuzzles[randomIndex])
        loadPuzzle(puzzleString: simplePuzzles[randomIndex])
    }
    
    func getPuzzles(name : String) -> [String] {
        let path = Bundle.main.path(forResource: name, ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        return array as! [String]
    }
    
    // e.g., write to plist compatible array (used for data persistence).
    func savedState() -> NSArray {
        let buttonTagsPortrait = [1, 2]
        return buttonTagsPortrait as NSArray
    }
    
    // e.g., read from plist compatible array (used for data persistence).
    func setState(puzzleArray: NSArray) {
        
    }
    
    // Load new game encoded with given string (see Section 4.1).
    func loadPuzzle(puzzleString: String) {
        var count = 0
        for character in puzzleString.characters {
            if (character == ".") {
                self.gameBoard[count / 9][count % 9].setNum(n: 0)
                self.gameBoard[count / 9][count % 9].setUnFixed()
            } else {
                self.gameBoard[count / 9][count % 9].setNum(n: Int(String(character))!)
                self.gameBoard[count / 9][count % 9].setFixed()
            }
            count += 1
        }
    }
    
    // Fetch the number stored in the cell at the specified row and column; zero indicates an empty cell or the cell holds penciled in values.
    func numberAtRow(row: Int, column: Int) -> Int {
        return self.gameBoard[row][column].getNum()
    }
    
    // Set the number at the specified cell; assumes cell does not contain a fixed number,
    func setNumber(number: Int, row: Int, column: Int) {
        self.gameBoard[row][column].setNum(n: number)
    }
    
    // Determines if cell contains a fixed number.
    func numberIsFixedAtRow(row: Int, column: Int) -> Bool {
        return self.gameBoard[row][column].getFixed()
    }
    
    // Does the number conflict with any other number in the same row, column, or 3 × 3 square?
    func isConflictingEntryAtRow(row: Int, column: Int) -> Bool {
        let num = gameBoard[row][column].getNum()
        
        // row
        for i in 0...8 {
            if (i != row && self.gameBoard[i][column].getNum() == num) {
                return true
            }
        }
        for i in 0...8 {
            if (i != column && self.gameBoard[row][i].getNum() == num) {
                return true
            }
        }
        
        let startRow = (row / 3) * 3
        let startCol = (column / 3) * 3
        for i in startRow...(startRow+2) {
            for j in startCol...(startCol+2) {
                if ((i != row && j != column) && self.gameBoard[i][j].getNum() == num) {
                    return true
                }
            }
        }
        
        return false
    }
    
    // Are the any penciled in values at the given cell (assumes number = 0)?
    func anyPencilSetAtRow(row: Int, column: Int) -> Bool {
        for i in 0...2 {
            for j in 0...2 {
                if (self.gameBoard[row][column].getPencilNums()[i][j] != 0) {
                    return true
                }
            }
        }
        return false
    }
    
    // Number of penciled in values at cell.
    func numberOfPencilsSetAtRow(row: Int, column: Int) -> Int {
        var count = 0
        for i in 0...2 {
            for j in 0...2 {
                if (self.gameBoard[row][column].getPencilNums()[i][j] != 0) {
                    count += 1
                }
            }
        }
        return count
    }
    
    // Is the value n penciled in?
    func isSetPencil(n: Int, row: Int, column: Int) -> Bool {
        return self.gameBoard[row][column].getPencilNums()[n % 3][n / 3] != 0
    }
    
    // Pencil the value n in.
    func setPencil(n: Int, row: Int, column: Int) {
        self.gameBoard[row][column].setPencilNum(row: n % 3, col: n / 3)
    }
    
    // Clear pencil value n.
    func clearPencil(n: Int, row: Int, column: Int) {
        self.gameBoard[row][column].clearPencilNum(row: n % 3, col: n / 3)
    }
    
    // Clear all penciled in values.
    func clearAllPencils(row: Int, column: Int) {
        for i in 0...2 {
            for j in 0...2 {
                self.gameBoard[row][column].clearPencilNum(row: i, col: j)
            }
        }
    }

}
