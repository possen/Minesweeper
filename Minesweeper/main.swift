//
//  main.swift
//  Minesweeper
//
//  Created by Paul Ossenbruggen on 6/5/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

//
// NOTE: this was developed in Xcode, it has some problems displaying correctly in the terminal, but looks good
// in xcode, see the description function to add a space, but even with this it does not look great in terminal.
// so I recommand running it in Xcode.
//

import Foundation

struct GameCommand {
    var game: Game?

    enum Errors: Error {
        case noCommand
        case badParameters
        case badCommand
        case noGame
    }
    
    init() {
    }
    
    private func help() {
        print("Enter Commands:")
        print("help - to print this help")
        print("new size mines - create a new board (ex. new 20 10)")
        print("reveal x y - reveal an area on the board. (ex. reveal 5 6)")
        print("mark x y - place a flag on board (ex. mark 5 6)")
        print("cheat - toggles cheat - show where bombs are hidden.")
        print("solve - show the solved board")
        print("Ctrl-D to end")
    }
    
    private func new(params: [Int]) throws -> Game {
        guard params.count == 2 else {
            throw Errors.badParameters
        }
        let (dimensions, mines) = ((params[0], params[0]), params[1])
        return try Game(board: Board(dimensions: dimensions, mines: mines))
    }
    
    private func reveal(params: [Int]) throws -> Bool? {
        let game = try checkGame()
        let (x, y) = try parameterCheck(game: game, params: params)
        try game.reveal(x: x, y: y)
        if game.checkLose() {
            return false
        }
        return nil
    }

    private func mark(params: [Int]) throws -> Bool? {
        let game = try checkGame()
        let (x, y) = try parameterCheck(game: game, params: params)
        try game.mark(x: x, y: y)
        if game.checkWin() {
            return true
        }
        return nil
    }
            
    private func checkGame() throws -> Game {
        guard let game = game else {
            throw Errors.noGame
        }
        return game
    }
    
    private func parameterCheck(game: Game, params: [Int]) throws -> (Int, Int) {
        guard params.count == 2 else {
            throw Errors.badParameters
        }
        return (params[0], params[1])
    }
    
    private mutating func processCommand(command: String) throws -> Bool? {
        let components = command.split(separator: " ")
        guard components.count > 0 else {
            throw Errors.noCommand
        }
        let params = components.compactMap { Int($0) }
        switch components[0] {
        case "new":
            game = try new(params: params)
        case "reveal":
            let lose = try reveal(params: params)
            return lose
        case "mark":
            let win = try mark(params: params)
            return win
        case "help":
            help()
        case "solve":
            let game = try checkGame()
            print("Solve")
            print(game.solved)
        case "cheat":
            let game = try checkGame()
            game.board.cheat.toggle()
            print("Cheat \(game.board.cheat ? "On" : "Off")")
        default:
            throw Errors.badCommand
        }
        return nil
    }
    
    mutating func readInput() {

        func showPrompt() {
            print("$> ", terminator: "")
        }

        help()
        showPrompt()
        while let command = readLine() {
            do {
                let winLose = try processCommand(command: command)
                print(game?.board.description ?? "No game, use 'new' to start.")
                if let wl = winLose {
                    print("You \(wl ? "Win!" : "Lose!")")
                    game = nil
                }
                showPrompt()
            } catch {
                print(error)
                showPrompt()
            }
        }
        print("done")
    }
}

var game = GameCommand()
game.readInput()

