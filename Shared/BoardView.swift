//
//  BoardView.swift
//  Minesweeper
//
//  Created by Paul Ossenbruggen on 6/25/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import SwiftUI

struct GameBoardView: View {
    var body: some View {
        return ScrollView([.horizontal, .vertical]) {
            ZStack {
                Color.blue.border( /*@START_MENU_TOKEN@*/
                    Color.black /*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/ 1 /*@END_MENU_TOKEN@*/)
                BoardBodyView(controller: SweeperController())
            }
        }
    }
}

struct BoardBodyView: View {
    @State var controller: SweeperController
    @State var pieces: [Board.Piece] = []

    var body: some View {
        if let board = controller.game?.board {
            BoardView(viewModel: .init(controller: controller, board: board, pieces: pieces))
                .task {
                    pieces = await board.pieces
                }
        } else {
            Text("fail")
        }
    }
}

struct BoardView: View {
    @State var viewModel: ViewModel

    func offset(_ x: Int, _ y: Int, dimension: Int) -> Int {
        y * dimension + x
    }

    var body: some View {
        let dimension = viewModel.pieces.count > 0 ? viewModel.board.dimensions.0 : 0
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<dimension, id: \.self) { y in
                GridRow {
                    ForEach(0..<dimension, id: \.self) { x in
                        PieceCellView(
                            controller: viewModel.controller,
                            piece: viewModel.pieces[offset(x, y, dimension: dimension)],
                            x: x,
                            y: y
                        )
                    }
                }
            }
        }
    }
}

extension BoardView {
    @Observable class ViewModel {
        private(set) var controller: SweeperController
        private(set) var board: Board
        private(set) var pieces: [Board.Piece]

        init(controller: SweeperController, board: Board, pieces: [Board.Piece]) {
            self.controller = controller
            self.board = board
            self.pieces = pieces
        }
    }
}

struct PieceCellView: View {
    var controller: SweeperController
    let piece: Board.Piece
    let x: Int
    let y: Int

    var body: some View {
        Text(convert(piece).rawValue)
            .font(.title)
            .onTapGesture {
                Task { [controller] in
                    await controller.reveal(x: x, y: y)
                }
            }
            .onLongPressGesture {
                Task { [controller] in
                    await controller.mark(x: x, y: y)
                }
            }
            .fixedSize(horizontal: true, vertical: true)
            .frame(width: 29, height: 29)
    }

    func convert(_ piece: Board.Piece) -> Board.Piece {
        var result = piece
        result = result == .empty ? .blank : result
        result = result == .hidden ? .covered : result
        return result
    }
}

extension Array {
    var isNotEmpty: Bool { !self.isEmpty }
}

#Preview {
    GameBoardView()
}
