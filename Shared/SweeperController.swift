//
//  SweeperController.swift
//  Minesweeper
//
//  Created by Paul Ossenbruggen on 6/23/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import Combine

class SweeperController: ObservableObject {
    var game: Game
    var board: Board
        
    init() {
        do {
            let board = try Board(dimensions: (40, 40), mines: 10)
            self.board = board
            game = Game(board: board)
        } catch {
            fatalError()
        }
    }
    
    func mark(x: Int, y: Int) {
        try? game.mark(x: x, y: y)
        objectWillChange.send()
    }
    
    func reveal(x: Int, y: Int) {
        try? game.reveal(x: x, y: y)
        objectWillChange.send()
    }
}
