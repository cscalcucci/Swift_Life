//
//  BoardView.swift
//  Swift_Life
//
//  Created by Christopher Scalcucci on 2/14/16.
//  Copyright © 2016 Christopher Scalcucci. All rights reserved.
//

import UIKit

class BoardView: UIView {

    // MARK:- INIT
    let board: Board

    init(board: Board) {
        self.board = board
        super.init(frame: CGRectMake(0,0,0,0))

        let singleFingerTap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        self.addGestureRecognizer(singleFingerTap)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- DRAWING TO BOARD
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        board.cellMatrix.forEach({ (_,_,cell) in
            CGContextSetFillColorWithColor(context, cell.colorForCell().CGColor)
            CGContextAddRect(context, frameForCell(cell))
            CGContextFillPath(context)
        })
    }

    private func cellAtPoint(point: CGPoint) -> Cell {
        let x = floor(point.x / (self.bounds.width / CGFloat(board.width)))
        let y = floor(point.y / (self.bounds.width / CGFloat(board.height)))

        return board.cellMatrix[Int(x),Int(y)]
    }

    private func frameForCell(cell: Cell) -> CGRect {

        func cellSize() -> CGSize {
            return CGSize(width: bounds.width / CGFloat(board.width), height: bounds.height / CGFloat(board.height))
        }

        func cellOrigin() -> CGPoint {
            return CGPoint(x: CGFloat(cell.position.x) * cellSize().width, y: CGFloat(cell.position.y) * cellSize().height)
        }

        return CGRect(origin: cellOrigin(), size: cellSize())
    }

    // MARK:- GESTURE HANDLING
    internal func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            let touchLocation: CGPoint = sender.locationInView(sender.view)
            cellAtPoint(touchLocation).toggleState()
            self.setNeedsDisplay()
        }
    }
}

