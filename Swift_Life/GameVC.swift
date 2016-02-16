//
//  GameVCTwo.swift
//  Swift_Life
//
//  Created by Christopher Scalcucci on 2/14/16.
//  Copyright © 2016 Christopher Scalcucci. All rights reserved.
//

import UIKit
import Foundation

class GameVC: UIViewController {

    // MARK:- INIT
    var timer: NSTimer!
    let boardView: BoardView!
    let board = Board(columns: 20, rows: 20)

    var ioButton    : UIButton!
    var newButton   : UIButton!
    var stepButton  : UIButton!
    var clearButton : UIButton!

    var timeLabel : UILabel!
    var timePassed : Int = 0 {
        didSet {
            timeLabel.text = "Time: \(timePassed)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
    }

    required init?(coder aDecoder: NSCoder) {
        boardView = BoardView(board: self.board)
        super.init(coder: aDecoder)
    }

    // MARK:- GAME LOGIC
    func tick() {
        board.step()
        boardView.setNeedsDisplay()
        timePassed++
    }

    func togglePlay() {
        ioButton.selected = !ioButton.selected
        if let _ = timer {
            timer.invalidate()
            timer = nil
        } else {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "tick", userInfo: nil, repeats: true)
        }
    }

    // Creates a 10-Cell row and clears the board, the 10-Cell row oscillates on period-15
    func oscillator() {
        board.clear()
        board.oscillator()
        boardView.setNeedsDisplay()
        timePassed = 0
    }

    // Creates a randomized game board after clearing the board
    func newGame() {
        board.clear()
        board.randomCells(200)
        boardView.setNeedsDisplay()
        timePassed = 0
    }

    // Clears the board
    func resetBoard() {
        board.clear()
        boardView.setNeedsDisplay()
        timePassed = 0
    }
}

// MARK:- SETUP UI
extension GameVC {
    func createUI() {
        let margin: CGFloat = 20.0
        let size = view.frame.width - margin * 2.0
        let frame = CGRectMake(margin, (view.frame.height - size) / 2.0, size, size)
        boardView.frame = frame
        boardView.layer.borderColor = UIColor.darkGrayColor().CGColor
        boardView.layer.borderWidth = 2.0
        view.addSubview(boardView)

        newButton   = UIButton(frame: CGRect(x: 60, y: view.frame.height - 100, width: 60, height: 60))
        ioButton    = UIButton(frame: CGRect(x: 150, y: view.frame.height - 100, width: 60, height: 60))
        stepButton  = UIButton(frame: CGRect(x: 240, y: view.frame.height - 100, width: 60, height: 60))
        clearButton = UIButton(frame: CGRect(x: 330, y: view.frame.height - 100, width: 60, height: 60))
        timeLabel   = UILabel(frame: CGRect(x: (view.frame.width / 2) - 75, y: view.frame.height - 35, width: 150, height: 30))

        ioButton.layer.masksToBounds = true
        ioButton.backgroundColor = .lightGrayColor()
        ioButton.layer.cornerRadius = 0.5 * ioButton.bounds.width
        ioButton.setTitle("Play", forState: .Normal)
        ioButton.setTitle("Pause", forState: .Selected)
        ioButton.setTitleColor(.greenColor(), forState: .Normal)
        ioButton.setTitleColor(.redColor(), forState: .Selected)
        ioButton.addTarget(self, action: "togglePlay", forControlEvents: .TouchUpInside)

        newButton.layer.masksToBounds = true
        newButton.backgroundColor = .lightGrayColor()
        newButton.layer.cornerRadius = 0.5 * newButton.bounds.width
        newButton.setTitle("New", forState: .Normal)
        newButton.setTitleColor(.purpleColor(), forState: .Normal)
        newButton.addTarget(self, action: "newGame", forControlEvents: .TouchUpInside)

        stepButton.layer.masksToBounds = true
        stepButton.backgroundColor = .lightGrayColor()
        stepButton.layer.cornerRadius = 0.5 * ioButton.bounds.width
        stepButton.setTitle("Next", forState: .Normal)
        stepButton.setTitleColor(.blueColor(), forState: .Normal)
        stepButton.addTarget(self, action: "tick", forControlEvents: .TouchUpInside)

        clearButton.layer.masksToBounds = true
        clearButton.backgroundColor = .lightGrayColor()
        clearButton.layer.cornerRadius = 0.5 * ioButton.bounds.width
        clearButton.setTitle("OSC", forState: .Normal)
        clearButton.setTitleColor(.yellowColor(), forState: .Normal)
        clearButton.addTarget(self, action: "oscillator", forControlEvents: .TouchUpInside)

        timeLabel.textAlignment = .Center
        timeLabel.text = "Time: \(timePassed)"

        view.addSubview(ioButton)
        view.addSubview(newButton)
        view.addSubview(stepButton)
        view.addSubview(clearButton)
        view.addSubview(timeLabel)

        view.bringSubviewToFront(ioButton)
        view.bringSubviewToFront(newButton)
        view.bringSubviewToFront(stepButton)
        view.bringSubviewToFront(clearButton)
        view.bringSubviewToFront(timeLabel)
    }
}
