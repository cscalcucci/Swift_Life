//
//  Matrix.swift
//  Swift_Life
//
//  Created by Christopher Scalcucci on 2/11/16.
//  Copyright © 2016 Christopher Scalcucci. All rights reserved.
//

import Foundation

public class Matrix<T> {

    public let width: Int
    public let height: Int
    private var elements: [T]

    public init(width: Int, height: Int, repeatedValue: T) {
        // Check for nil
        assert(width >= 0,  "Matrix<T> critical error, Matrix.width  >= 0")
        assert(height >= 0, "Matrix<T> critical error, Matrix.height >= 0")

        self.width = width
        self.height = height
        elements = Array<T>(count: width*height, repeatedValue: repeatedValue)
    }

    /// Gets an element in the matrix using it's x and y position
    public subscript(x: Int, y: Int) -> T {
        get {
            assert(x >= 0 && x < self.width,  "Matrix<T> critical error, X >= 0 && X < Matrix.width")
            assert(y >= 0 && y < self.height, "Matrix<T> critical error, X >= 0 && X < Matrix.height")

            return elements[x + (y * width)]
        }
        set(newValue) {
            assert(x >= 0 && x < self.width,  "Matrix<T> critical error, X >= 0 && X < Matrix.width")
            assert(y >= 0 && y < self.height, "Matrix<T> critical error, X >= 0 && X < Matrix.height")

            elements[x + (y * width)] = newValue
        }
    }
}

extension Matrix: SequenceType {
    public func generate() -> MatrixGenerator<T> {
        return MatrixGenerator(matrix: self)
    }

//    public func filter<T>(includeElement: (T) -> Bool) -> Matrix<T> {
//        return self._elements.filter(includeElement)
//    }
}

public class MatrixGenerator<T>: GeneratorType {

    private let matrix: Matrix<T>
    private var x = 0
    private var y = 0

    init(matrix: Matrix<T>) {
        self.matrix = matrix
    }

    public func next() -> (x: Int, y: Int, element: T)? {
        // Check for nil
        if self.x >= matrix.width { return nil }
        if self.y >= matrix.height { return nil }

        // Extract the element and increase the counters
        let returnValue = (x, y, matrix[x, y])

        // Increase the counters
        ++x; if x >= matrix.width { x = 0; ++y }

        return returnValue
    }
    
}