//
//  Board.swift
//  Swift_Life
//
//  Created by Christopher Scalcucci on 2/11/16.
//  Copyright © 2016 Christopher Scalcucci. All rights reserved.
//


import Foundation
import UIKit

class Board {

    // MARK:- INIT
    internal var width = 10
    internal var height = 10
    internal var cellMatrix: Matrix<Cell!>!

    lazy private var cellsByState : (currentState:State) -> [Cell]  = { (currentState: State) -> [Cell] in
        return self.cellMatrix.map { (_,_,cell) in cell }.filter{ (cell: Cell) in cell.state == currentState }
    }

    init(columns: Int, rows: Int) {
        width = columns
        height = rows

        cellMatrix = Matrix<Cell!>(width: width, height: height, repeatedValue: nil)

        // Fill the matrix with cells & prefetch each cell's valid neighbors
        cellMatrix.forEach({ (x, y, _) in cellMatrix[x,y] = Cell(position: (x,y)) })
        cellMatrix.forEach({ (_,_, cell) in cell.neighbours = fetchValidNeighbors(cell.position) })
    }

    subscript (x: Int, y: Int) -> Cell? {
        return cellMatrix[x,y]
    }

    // MARK:- GAME LOGIC
    func step() {
        let cellsToLive = cellsByState(currentState: .Dead).filter { $0.cellShouldLive() }
        let cellsToDie  = cellsByState(currentState: .Alive).filter { $0.cellShouldLive() }

        cellsToLive.forEach { cell in cell.state = .Alive }
        cellsToDie.forEach  { cell in cell.state = .Dead }
    }

    // NeighborsDelta is an array [(x,y)] containing all the delta cartesian coords to find a position's 8 neighbors
    func neighborsDelta() -> [(Int, Int)] {
        return [(-1, -1), (0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0)]
    }

    // Calls a map function to get an array of neighbor positions for any given position in a matrix, then filters out invalid neighbors
    func fetchValidNeighbors(position: Coordinate) -> [Cell] {
        return getNeighbors(position)
                .filter({ x in isValidPosition(x) })
                .map(mapPosition)
    }

    // Maps the array of delta coords to a position in the matrix, this creates 8 coords that represent all neighboring cells
    func getNeighbors(position: Coordinate) -> [Coordinate] {
        return neighborsDelta().map { (x, y) in (position.x + x, position.y + y) }
    }

    // Converts the neighbor's position coords of neighbors into their respective cells inside the matrix
    func mapPosition(position: Coordinate) -> Cell {
        return cellMatrix[position.x, position.y]
    }

    // Check is called first to make sure we don't throw Matrix's size assertion, as outer edges might not have all 8 neigbbors.
    func isValidPosition(position: Coordinate) -> Bool {
        return (position.x >= 0 && position.x < cellMatrix.width) && (position.y >= 0 && position.y < cellMatrix.height)
    }

    // MARK:- BOARD LOGIC

    func clear() {
        cellMatrix.forEach({ (_, _, cell) in cell.state = .Dead })
    }

    func randomCells(amount: Int) {
        func randLocation () -> Int {
            return Int(arc4random()) % self.height
        }

        for _ in 0...amount {
            let x = randLocation(), y = randLocation()
            cellMatrix[x, y]!.state = .Alive
        }
    }

    func oscillator() {
        let osc = [(4,5),(5,5),(6,5),(7,5),(8,5),(9,5),(10,5),(11,5),(12,5),(13,5)]

        osc.forEach({ (x,y) in cellMatrix[x,y]!.state = .Alive })
    }
}