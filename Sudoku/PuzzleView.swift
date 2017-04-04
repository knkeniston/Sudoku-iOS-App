//
//  PuzzleView.swift
//  Sudoku
//
//  Created by Kelly Keniston on 3/5/17.
//  Copyright © 2017 Kelly Keniston. All rights reserved.
//

import UIKit

class PuzzleView: UIView {
    
    var selectedSquare = (row : -1, col : -1)
    var puzzle : SudokuPuzzle!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        puzzle = SudokuPuzzle()
        NSLog("ChessView:init(decoder)")
        addMyTapGestureRecognizer()
    }
    
    func boardRect() -> CGRect {
        let margin : CGFloat = 10
        let size = ceil((min(self.bounds.width, self.bounds.height) - margin)/8.0)*8.0
        let center = CGPoint(x: self.bounds.width/2,
                             y :self.bounds.height/2)
        let boardRect = CGRect(x: center.x - size/2,
                               y: center.y - size/2,
                               width: size, height: size)
        return boardRect
    }

    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            
            let boardRect = self.boardRect()
            
            UIColor.black.setStroke()
            UIColor.black.setFill()
            
            context.stroke(boardRect, width: 6.0)
            
            let boldFont = UIFont(name: "Helvetica-Bold", size: 30)
            var fixedAttributes = [NSFontAttributeName : boldFont!, NSForegroundColorAttributeName : UIColor.black]
            let pencilFont = UIFont(name: "Helvetica-Bold", size: 10)
            let pencilAttributes = [NSFontAttributeName : pencilFont!, NSForegroundColorAttributeName : UIColor.black]
            let squareSize = boardRect.size.width / 9
            let delta = boardRect.size.height / 3
            let d = delta / 3
            let s = d / 3
            
            if selectedSquare.row >= 0 && selectedSquare.col >= 0 {
                UIColor.gray.setFill()
                let x = boardRect.origin.x + CGFloat(selectedSquare.col)*squareSize
                let y = boardRect.origin.y + CGFloat(selectedSquare.row)*squareSize
                context.fill(CGRect(x: x, y: y, width: squareSize, height: squareSize))
            }
            
            for row in 0...2 {
                for col in 0...2 {
                    let deltaRect = CGRect(x: boardRect.origin.x + CGFloat(col * 3)*d,
                                           y: boardRect.origin.x + CGFloat(row * 3)*d,
                                           width: delta, height: delta)
                    context.stroke(deltaRect, width: 4.0)
                }
            }
            
            for row in 0...8 {
                for col in 0...8 {
                    let dRect = CGRect(x: boardRect.origin.x + CGFloat(col)*d,
                                       y: boardRect.origin.x + CGFloat(row)*d,
                                       width: d, height: d)
                    context.stroke(dRect, width: 2.0)
                }
            }
            
            for row in 0...8 {
                for col in 0...8 {
                    
                    if (puzzle.numberAtRow(row: row, column: col) != 0) {
                        let text = String(puzzle.numberAtRow(row: row, column: col)) as NSString
                        let textSize = text.size(attributes: fixedAttributes)
                        let x = boardRect.origin.x + CGFloat(col)*d + 0.5*(d - textSize.width)
                        let y = boardRect.origin.y + CGFloat(row)*d + 0.5*(d - textSize.height)
                        let textRect = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
                        if (!puzzle.numberIsFixedAtRow(row: row, column: col)) {
                            if (puzzle.isConflictingEntryAtRow(row: row, column: col)) {
                                fixedAttributes = [NSFontAttributeName : boldFont!, NSForegroundColorAttributeName : UIColor.red]
                            } else {
                                fixedAttributes = [NSFontAttributeName : boldFont!, NSForegroundColorAttributeName : UIColor.blue]
                            }
                            text.draw(in: textRect, withAttributes: fixedAttributes)
                            fixedAttributes = [NSFontAttributeName : boldFont!, NSForegroundColorAttributeName : UIColor.black]
                        } else {
                            text.draw(in: textRect, withAttributes: fixedAttributes)
                        }
                    } else if (puzzle.anyPencilSetAtRow(row: row, column: col)) {
                        
                        var n = 0
                        for i in 0...2 {
                            for j in 0...2 {
                                if (puzzle.isSetPencil(n: n, row: row, column: col)) {
                                    let text = String(n + 1) as NSString
                                    let textSize = text.size(attributes: pencilAttributes)
                                    let x = boardRect.origin.x + CGFloat(col)*d + CGFloat(j)*s + 0.5*(s - textSize.width)
                                    let y = boardRect.origin.y + CGFloat(row)*d + CGFloat(i)*s + 0.5*(s - textSize.height)
                                    let textRect = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
                                    text.draw(in: textRect, withAttributes: pencilAttributes)
                                }
                                n += 1
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addMyTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PuzzleView.tap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func tap(_ sender: UITapGestureRecognizer?) {
        NSLog("tap")
        if let location = sender?.location(in: self) {
            NSLog("tap \(location)")
            let boardRect = self.boardRect()
            let delta = boardRect.size.height / 3
            let d = delta / 3
            if (boardRect.contains(location)) {
                NSLog("inside board!")
                let col = Int((location.x - boardRect.origin.x)/d)
                let row = Int((location.y - boardRect.origin.y)/d)
                if (0 ... 8) ~= col && (0 ... 8) ~= row {
                    if row != selectedSquare.row || col != selectedSquare.col {
                        selectedSquare.row = row
                        selectedSquare.col = col
                        self.setNeedsDisplay()
                    }
                }
            }
        }
    }
    
    let buttonTagsPortrait = [ // 2x6 button layout
        [1, 2, 3, 4, 5, 11], // tags assigned in IB
        [6, 7, 8, 9, 10, 12]
    ]
    let buttonTagsPortraitTall = [
        [1, 2, 3, 11],
        [4, 5, 6, 10],
        [7, 8, 9, 12]
    ] // 3x4 layout
    let buttonTagsLandscape = [
        [1, 6],
        [2, 7],
        [3, 8],
        [4, 9],
        [5, 11],
        [10, 12]
    ] // 6x2 layout
    let buttonTagsLandscapeTall = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
        [11, 10, 12]
    ] // 4x3 layout
    let aspectRatiosForLayouts : [Float] = [
        3.0, // 2 x 6
        4.0/3, // 3 x 4
        1.0/3, // 6 x 2
        3.0/4 // 4 x 3
    ]
    override func layoutSubviews() {
        super.layoutSubviews() // let Auto Layout finish
        let aspectRatio = Float(self.bounds.size.width / self.bounds.size.height)
        var closestLayout = 0
        var closestLayoutDiff = fabsf(aspectRatio - aspectRatiosForLayouts[0])
        for i in 1 ..< 4 {
            let diff = fabsf(aspectRatio - aspectRatiosForLayouts[i])
            if (diff < closestLayoutDiff) {
                closestLayout = i
                closestLayoutDiff = diff
            }
        }
        let buttonTagsFlavors = [
            buttonTagsPortrait, buttonTagsPortraitTall, buttonTagsLandscape, buttonTagsLandscapeTall
        ]
        let buttonTags = buttonTagsFlavors[closestLayout]
        func integersWithSum(sum : Int, count : Int) -> [Int] {
            var ints = [Int](repeating: sum / count, count: count)
            let r = sum % count
            for i in 0 ..< r {ints[i] += 1}
            return ints
        }
        let inset = 1
        let W = Int(self.bounds.width) - 2*inset, H = Int(self.bounds.height) - 2*inset
        let numColumns = buttonTags[0].count, numRows = buttonTags.count
        let widths = integersWithSum(sum: W, count: numColumns)
        let heights = integersWithSum(sum: H, count: numRows)
        var y = CGFloat(inset)
        for r in 0 ..< numRows {
            let h = CGFloat(heights[r])
            var x = CGFloat(inset)
            for c in 0 ..< numColumns {
                let w = CGFloat(widths[c])
                let button = self.viewWithTag(buttonTags[r][c])
                button?.bounds = CGRect(x: 0, y: 0, width: w, height: h)
                button?.center = CGPoint(x: x + w/2, y: y + h/2)
                x += w
            }
            y += h
        }
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(self.puzzle, forKey: "puzzle")
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        self.puzzle = coder.decodeObject(forKey: "puzzle") as! SudokuPuzzle!
        super.decodeRestorableState(with: coder)
    }
    
    
}
