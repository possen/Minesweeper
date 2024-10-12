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
        let board = controller.game.board

        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<board.dimensions.1, id: \.self) { y in
                GridRow {
                    ForEach(0..<board.dimensions.0, id: \.self) { x in
                        PieceCellView(x: x, y: y)
                    }
                }
            }
        }
    }

}

struct PieceCellView: View {
    @EnvironmentObject var controller: SweeperController
    let x: Int
    let y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    var body: some View {
        let board = controller.game.board

        Text(LocalizedStringKey(convert(board.piece(x: x, y: y)!).rawValue))
            .font(.title)
            .onTapGesture {
                controller.reveal(x: x, y: y)
            }.onLongPressGesture {
                controller.mark(x: x, y: y)
            }.fixedSize(horizontal: true, vertical: true)
            .frame(width: 29, height: 29)
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
