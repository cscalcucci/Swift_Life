//
//  Cell.swift
//  Swift_Life
//
//  Created by Christopher Scalcucci on 2/11/16.
//  Copyright © 2016 Christopher Scalcucci. All rights reserved.
//

import UIKit

public typealias Coordinate = (x: Int, y: Int)

class Cell {

    let position: Coordinate!
    var state: State
    var neighbours: [Cell]!

    lazy private var livingNeighbours : () -> [Cell] = { () -> [Cell] in
        return self.neighbours.filter { $0.state == State.Alive }
    }

    lazy var colorForCell : () -> UIColor = { () -> UIColor in
        return self.state.fillColor()
    }

    var hashValue: Int {
        return position.x + position.y * 1_000
    }

    init(position: Coordinate) {
        self.position = position
        self.neighbours = [Cell]()
        self.state = .Dead
    }

    func cellShouldLive() -> Bool {
        switch state {
            case .Dead  : return livingNeighbours().count == 3
            case .Alive : return livingNeighbours().count !~= 2...3
        }
    }

    func toggleState() {
        switch state {
            case .Alive : state = .Dead
            case .Dead  : state = .Alive
        }
    }

//    func cellShouldLive(fn: (State,Int) -> Bool) -> Bool {
//        return fn(state, neighbours.filter{ $0.state == State.Alive }.count)
//    }
}

func == (lhs: Cell, rhs: Cell) -> Bool {
    return lhs.position.x == rhs.position.x && lhs.position.y == rhs.position.y
}

enum State {
    case Alive, Dead

    func fillColor() -> UIColor {
        switch self {
            case .Alive : return .blueColor()
            case .Dead  : return .lightGrayColor()
        }
    }
}

infix operator !~= {}

func !~= <I : IntervalType>(value: I.Bound, pattern: I) -> Bool {
    return !(pattern ~= value)
}