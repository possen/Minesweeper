//
//  SweeperController.swift
//  Minesweeper
//
//  Created by Paul Ossenbruggen on 6/23/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import Foundation

@MainActor @Observable
class NewGameController {
    var size: Double // Double becasue sliders need Double
    var mines: Double

    init() {
        self.size = Double(13)
        self.mines = Double(28)
    }
}

@MainActor @Observable
class SweeperController {
    var game: Game?
    var state: State = .playing
    var size = 13
    var mines = 28

    enum State {
        case win
        case lose
        case playing
    }

    init() {
        Task {
            self.game = await Self.newGame(size: size, mines: mines)
        }
    }

    static func newGame(size: Int, mines: Int) async -> Game? {
        do {
            let board = try Board(dimensions: (size, size), mines: mines)
            return await Game(board: board)
        } catch {
            return nil
        }
    }

    func reset() async {
        let result = await Self.newGame(size: Int(size), mines: Int(mines))
        self.game = result
        state = .playing
    }

    @discardableResult
    func mark(x: Int, y: Int) async -> Bool {
        guard let game else {
            return false
        }
        try? await game.mark(x: x, y: y)
        let win = await game.checkWin()
        if win {
            state = .win
        }
        return false
    }

    @discardableResult
    func reveal(x: Int, y: Int) async -> Bool {
        guard let game else {
            return false
        }
        try? await game.reveal(x: x, y: y)
        let lose = await game.checkLose()
        if lose {
            state = .lose
        }
        return false
    }

    func piece(x: Int, y: Int) async -> Board.Piece? {
        guard let game else {
            return nil
        }
        return await game.piece(x: x, y: y)
    }
}
