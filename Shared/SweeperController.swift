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
    @Published var difficulty = 40.0
    
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
        self.game = Self.newGame(size: Int(size), diffculty: Int(difficulty))
        state = .playing
        objectWillChange.send()
    }
    
    func mark(x: Int, y: Int) -> Bool {
        _ = try? game.mark(x: x, y: y)
        let win = game.checkWin()
        if win {
            state = .win
        }
        objectWillChange.send()
        return win
    }
    
    func reveal(x: Int, y: Int) -> Bool {
        _ = try? game.reveal(x: x, y: y)
        let lose = game.checkLose()
        if lose {
            state = .lose
        }
        objectWillChange.send()
        return lose
    }
}
