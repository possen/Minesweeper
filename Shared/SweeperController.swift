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
    var game: Game?
    @Published var state: State = .playing
    @Published var size: Double
    @Published var mines: Double

    enum State {
        case win
        case lose
        case playing
    }
    
    init() {
        let size = 13
        let mines = 28
        self.size = Double(size)
        self.mines = Double(mines)
        Task {
            game = await Self.newGame(size: size, mines: mines)
        }
    }
    
    static func newGame(size: Int, mines: Int) async -> Game {
        do {
            let board = try await Board(dimensions: (size, size), mines: mines)
            return await Game(board: board)
        } catch {
            fatalError()
        }
    }
    
    func reset() async {
        let result = await Self.newGame(size: Int(size), mines: Int(mines))
        self.game = result
        Task { @MainActor in
            state = .playing
            objectWillChange.send()
        }
    }

    @discardableResult
    func mark(x: Int, y: Int) async -> Bool {
        guard let game else {
            return false
        }
        try? await game.mark(x: x, y: y)
        let win = await game.checkWin()
        Task { @MainActor in
            if win {
                state = .win
            }
            objectWillChange.send()
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
        Task { @MainActor in
            if lose {
                state = .lose
            }
            objectWillChange.send()
        }
        return false
    }
}
