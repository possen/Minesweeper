//
//  SweeperController.swift
//  Minesweeper
//
//  Created by Paul Ossenbruggen on 6/23/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import Combine
import Foundation


class SweeperController: ObservableObject {
    var game: Game
    var state: State = .playing
    @Published var size = 40.0
    @Published var mines = 40.0
    
    enum State {
        case win
        case lose
        case playing
    }
    
    init() {
        game = Self.newGame(size: 40, diffculty: 40)
    }
    
    static func newGame(size: Int, diffculty: Int) -> Game {
        do {
            let board = try Board(dimensions: (size, size), mines: diffculty)
            return Game(board: board)
        } catch {
            fatalError()
        }
    }
    
    func reset() {
        DispatchQueue.global().async { [self] in
            let result = Self.newGame(size: Int(size), diffculty: Int(mines))
            DispatchQueue.main.async { [self] in
                objectWillChange.send()
                self.game = result
                state = .playing
            }
        }
    }

    @discardableResult
    func mark(x: Int, y: Int) -> Bool {
        DispatchQueue.global().async { [self] in
            _ = try? game.mark(x: x, y: y)
            let win = game.checkWin()
            if win {
                state = .win
            }
            DispatchQueue.main.async { [self] in
                objectWillChange.send()
            }
        }
        return false
    }

    @discardableResult
    func reveal(x: Int, y: Int) -> Bool {
        DispatchQueue.global().async { [self] in
            try? game.reveal(x: x, y: y)
            let lose = game.checkLose()
            if lose {
                state = .lose
            }
            DispatchQueue.main.async { [self] in
                objectWillChange.send()
            }
        }
        return false
    }
}
