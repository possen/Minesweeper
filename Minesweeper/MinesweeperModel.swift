//
//  MinesweeperModel.swift
//  Minesweeper
//
//  Created by Paul Ossenbruggen on 6/7/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import Foundation

class Board: CustomStringConvertible {
    private let pieceMap = Array(Piece.allCases.enumerated())
    fileprivate let mines: Int
    var cheat: Bool
    let dimensions: (Int, Int)
    var pieces: [Piece]

    enum Errors: Error {
        case boardSizeInvalid
        case numberOfMinesInvalid
        case badCommand
        case tooManyMines
        case badParameters
    }

    // extra space help on Terminal for double wide unicode. For certain emoji.
    enum Piece: String, CaseIterable {
        case empty =      "⏹"
        case number1 =    "1️⃣"
        case number2 =    "2️⃣"
        case number3 =    "3️⃣"
        case number4 =    "4️⃣"
        case number5 =    "5️⃣"
        case number6 =    "6️⃣"
        case number7 =    "7️⃣"
        case number8 =    "8️⃣"
        case bomb =       "💣"
        case flag =       "📍"
        case covered =    "❇️"
        case hidden =     "✳️" // hidden bomb, mapped to covered when displaying.
        case blank =      " "
    }

    init(dimensions: (Int, Int), mines: Int) throws {
        guard dimensions.0 > 0 && dimensions.1 > 0 else {
            throw Errors.boardSizeInvalid
        }
        guard mines > 0 else {
            throw Errors.numberOfMinesInvalid
        }
        guard mines <= dimensions.0 * dimensions.1 else {
            throw Errors.tooManyMines
        }
        self.cheat = false
        self.mines = mines
        self.dimensions = dimensions
        self.pieces = Array(repeating: Piece.covered, count: dimensions.0 * dimensions.1)
        var availablePositions = Array(pieces.indices) /// to ensure we don't reuse same random position.
        (0..<mines).forEach { index in
            guard let index = availablePositions.randomElement() else {
                return
            }
            availablePositions.removeAll { index == $0 }
            pieces[index] = .hidden
        }
    }
    
    private init(original: Board) {
        self.cheat = original.cheat
        self.dimensions = original.dimensions
        self.pieces = original.pieces
        self.mines = original.mines
    }
    
    fileprivate func copy() -> Board {
        Board(original: self)
    }
    
    fileprivate func offset(_ x: Int, _ y: Int) -> Int {
        y * dimensions.0 + x
    }
    
    fileprivate func offset(_ tup: (Int, Int)) -> Int {
        offset(tup.0, tup.1)
    }
    
    func piece(x: Int, y: Int) -> Piece? {
        guard checkOnBoard(x: x, y: y) else {
            return nil
        }
        return pieces[offset(x, y)]
    }
    
    fileprivate func setPiece(x: Int, y: Int, piece: Piece) {
        guard checkOnBoard(x: x, y: y) else {
            return
        }
        pieces[offset(x, y)] = piece
    }

    var description: String {
        let str = (0..<dimensions.1).reduce(into: "") { strout, y in
            strout += (0..<dimensions.0).reduce(into: "") { strin, x in
                guard let val = piece(x: x, y: y) else {
                    return
                }
                let modified = (!cheat && val == .hidden)
                    ? .covered
                    : val
                strin += modified.rawValue
            }
            strout += "\n"
        }
        return str
    }
    
    fileprivate func visit(each: (Int, Int) -> Void) {
        (0..<dimensions.1).forEach { y in
            (0..<dimensions.0).forEach { x in
                each(x, y)
            }
        }
    }
    
    fileprivate func reveal(x: Int, y: Int) throws -> [(Int, Int)] {
        guard checkOnBoard(x: x, y: y) else {
            throw Errors.badParameters
        }
        let value = piece(x: x, y: y)
        if value == .hidden {
            setPiece(x: x, y: y, piece: .bomb)
        }
        return floodFill(x: x, y: y)
    }
    
    fileprivate func mark(x: Int, y: Int) throws {
        guard checkOnBoard(x: x, y: y) else {
            throw Errors.badParameters
        }
        let value = piece(x: x, y: y)
        if value == .hidden || value == .covered {
            setPiece(x: x, y: y, piece: .flag)
        }
    }
    
    fileprivate func checkOnBoard(x: Int, y: Int) -> Bool {
        0..<dimensions.0 ~= x && 0..<dimensions.1 ~= y
    }
    
    fileprivate func countNeighbors(x: Int, y: Int) -> Int {
        [(x+1, y), (x-1, y), (x, y+1), (x, y-1), (x+1, y+1), (x-1, y+1), (x+1, y-1), (x-1, y-1)].reduce(0) {
          $0 + (piece(x: $1.0, y: $1.1) == .hidden ? 1 : 0)
        }
    }
    
    fileprivate func pieceForCount(_ val: Int) -> Piece {
        pieceMap.first { $0.offset == val }?.element ?? .empty
    }
    
    fileprivate func floodFill(x: Int, y: Int) -> [(Int, Int)] {
        let directions = [(+1, 0), (0, +1), (-1, 0),(0, -1)]
        var visited = [Bool](repeating: false, count: dimensions.0 * dimensions.1)
        var queue: [(Int, Int)] = []
        var result: [(Int, Int)] = []
        queue += [(x, y)]
        while !queue.isEmpty {
            guard let loc = queue.popLast(), !visited[offset(loc)], let value = piece(x: loc.0, y: loc.1) else {
                continue
            }
            visited[offset(loc)] = true
            directions.forEach { dir in
                if value == .empty {
                    let coords = (loc.0 + dir.0, loc.1 + dir.1)
                    if checkOnBoard(x: coords.0, y: coords.1) {
                        queue.push(coords)
                    }
                }
                result += [loc]
            }
        }
        return result
    }
}

extension Array {
    mutating func push(_ element: Element) {
        append(element)
    }
}

struct Game {
    let solved: Board
    var board: Board

    init(board: Board) {
        self.solved = board.copy()
        self.board = board
        // solved board shows all pieces and their counts and allows unmarking flag.
        board.visit { x, y in
            let value = solved.piece(x: x, y: y)
            if value != .hidden {
                solved.setPiece(x: x, y: y, piece: solved.pieceForCount(solved.countNeighbors(x: x, y: y)))
            }
        }
    }
    
    func reveal(x: Int, y: Int) throws {
        let coords = try solved.reveal(x: x, y: y)
        coords.forEach { x, y in board.setPiece(x: x, y: y, piece: solved.piece(x: x, y: y) ?? .empty) }
    }
    
    func mark(x: Int, y: Int) throws {
        let piece = board.piece(x: x, y: y)
        if piece == .flag { // restore
            board.setPiece(x: x, y: y, piece: solved.piece(x: x, y: y)!)
        } else {
            try board.mark(x: x, y: y)
        }
    }

    func checkWin() -> Bool {
        // match up flags to bombs, if they all match then win
        let pairs = zip(solved.pieces, board.pieces)
        let matches = pairs.map { $0.0 == .hidden && $0.1 == .flag }
        let win = matches.reduce(0) { $0 + ($1 ? 1 : 0) } == solved.mines
        return win
    }
    
    func checkLose() -> Bool {
        let loss = board.pieces.filter { $0 == .bomb }.count > 0
        if loss { // show all bombs
            board.pieces = board.pieces.map { $0 == .hidden ? .bomb : $0 } // convert hidden bombs to shown bombs
        }
        return loss
    }
}
