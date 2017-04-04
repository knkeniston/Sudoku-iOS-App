//
//  ViewController.swift
//  Sudoku
//
//  Created by Kelly Keniston on 3/5/17.
//  Copyright © 2017 Kelly Keniston. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var puzzleView: PuzzleView!
    var pencilEnabled : Bool = false // controller property

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pencilPressed(_ sender: UIButton) {
        pencilEnabled = !pencilEnabled // toggle
        sender.isSelected = pencilEnabled
    }
    
    @IBAction func menuPressed(_ sender: UIButton) {
        let puzzle = puzzleView.puzzle
        let alertController = UIAlertController(
            title: "Main Menu",
            message: nil,
            preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        alertController.addAction(UIAlertAction(
            title: "New Easy Game",
            style: .default,
            handler: { (UIAlertAction) -> Void in
                let randomIndex = Int(arc4random_uniform(UInt32((puzzle?.simplePuzzles.count)!)))
                puzzle?.loadPuzzle(puzzleString: (puzzle?.simplePuzzles[randomIndex])!)
                self.puzzleView.setNeedsDisplay()}))
        alertController.addAction(UIAlertAction(
            title: "New Hard Game",
            style: .default,
            handler: { (UIAlertAction) -> Void in
                let randomIndex = Int(arc4random_uniform(UInt32((puzzle?.hardPuzzles.count)!)))
                puzzle?.loadPuzzle(puzzleString: (puzzle?.simplePuzzles[randomIndex])!)
                self.puzzleView.setNeedsDisplay()}))
        self.present(alertController, animated: true, completion: nil)

    }

    @IBAction func deletePressed(_ sender: UIButton) {
        let puzzle = puzzleView.puzzle
        let selectedSquare = puzzleView.selectedSquare
        if (selectedSquare.col != -1 && selectedSquare.row != -1) {
            if (!pencilEnabled) {
                if (!(puzzle?.numberIsFixedAtRow(row: selectedSquare.row, column: selectedSquare.col))!) {
                    puzzle?.setNumber(number: 0, row: selectedSquare.row, column: selectedSquare.col)
                    self.puzzleView.setNeedsDisplay()
                }
            }
            if (puzzle?.anyPencilSetAtRow(row: selectedSquare.row, column: selectedSquare.col))! {
                let alertController = UIAlertController(
                    title: "Deleting all penciled in numbers at cell",
                    message: "Are you sure?",
                    preferredStyle: .alert)
                alertController.addAction(UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: nil))
                alertController.addAction(UIAlertAction(
                    title: "Yes",
                    style: .default,
                    handler: { (UIAlertAction) -> Void in
                        puzzle?.clearAllPencils(row: selectedSquare.row, column: selectedSquare.col)
                        self.puzzleView.setNeedsDisplay()
                }))
                self.present(alertController, animated: true, completion: nil)

            }
            
        }

    }
    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        let puzzle = puzzleView.puzzle
        var num = sender.tag
        let selectedSquare = puzzleView.selectedSquare
        if (!pencilEnabled) {
            if (selectedSquare.col != -1 && selectedSquare.row != -1) {
                if (puzzle?.numberAtRow(row: selectedSquare.row, column: selectedSquare.col) == num &&
                    !(puzzle?.numberIsFixedAtRow(row: selectedSquare.row, column: selectedSquare.col))!) {
                    puzzle?.setNumber(number: 0, row: selectedSquare.row, column: selectedSquare.col)
                } else if (!(puzzle?.numberIsFixedAtRow(row: selectedSquare.row, column: selectedSquare.col))!) {
                    puzzle?.setNumber(number: num, row: selectedSquare.row, column: selectedSquare.col)
                }
                puzzle?.clearAllPencils(row: selectedSquare.row, column: selectedSquare.col)
                puzzleView.setNeedsDisplay()
            }
        } else {
            num -= 1
            if (selectedSquare.col != -1 && selectedSquare.row != -1) {
                if ((puzzle?.isSetPencil(n: num, row: selectedSquare.row, column: selectedSquare.col))! &&
                    !(puzzle?.numberIsFixedAtRow(row: selectedSquare.row, column: selectedSquare.col))!) {
                    puzzle?.clearPencil(n: num, row: selectedSquare.row, column: selectedSquare.col)
                } else if (!(puzzle?.numberIsFixedAtRow(row: selectedSquare.row, column: selectedSquare.col))!) {
                    puzzle?.setPencil(n: num, row: selectedSquare.row, column: selectedSquare.col)
                }
                puzzleView.setNeedsDisplay()
            }
        }
    }
}

