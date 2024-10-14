//
//  BoardView.swift
//  Minesweeper
//
//  Created by Paul Ossenbruggen on 6/25/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import SwiftUI

struct BoardView: View {
    var body: some View {
        return ScrollView([.horizontal, .vertical]) {
            ZStack {
                Color.blue.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                BoardBodyView()
            }
        }
    }
}

struct BoardBodyView: View {
    @EnvironmentObject var controller: SweeperController

    var body: some View {
        if let game = controller.game {
            Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                ForEach(0..<game.board.dimensions.1, id: \.self) { y in
                    GridRow {
                        ForEach(0..<game.board.dimensions.0, id: \.self) { x in
                            PieceCellView(x: x, y: y)
                        }
                    }
                }
            }
        } else {
            Text("fail")
        }
    }
}

struct PieceCellView: View {
    @EnvironmentObject var controller: SweeperController
    let x: Int
    let y: Int
    
    var body: some View {
        if let game = controller.game {
            Text(LocalizedStringKey(convert(game.board.piece(x: x, y: y) ?? Board.Piece.blank).rawValue))
                .font(.title)
                .onTapGesture {
                    Task {
                        await controller.reveal(x: x, y: y)
                    }
                }
                .onLongPressGesture {
                    Task {
                        await controller.mark(x: x, y: y)
                    }
                }
                .fixedSize(horizontal: true, vertical: true)
                .frame(width: 29, height: 29)
        } else {
            Text("failure")
        }
    }

    func convert(_ piece: Board.Piece) -> Board.Piece {
        var result = piece
        result = result == .empty ? .blank : result
        result = result == .hidden ? .covered : result
        return result
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
