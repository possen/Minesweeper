//
//  BoardView.swift
//  Minesweeper
//
//  Created by Paul Ossenbruggen on 6/25/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import SwiftUI


struct BoardView: View {
    @EnvironmentObject var controller: SweeperController
    
    var body: some View {
        let board = controller.game.board
        return ScrollView([.horizontal, .vertical]) {
            ZStack {
                Color.blue.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                VStack(spacing: 0) {
                    ForEach(0..<board.dimensions.1, id: \.self) { y in
                        HStack(spacing: 0) {
                            ForEach(0..<board.dimensions.0, id: \.self) { x in
                                Text(LocalizedStringKey(convert(board.piece(x: x, y: y)!).rawValue))
                                    .font(.title)
                                    .onTapGesture {
                                        let lose = controller.reveal(x: x, y: y)
                                        print("reveal: ", x, y, lose)
                                    }.onLongPressGesture {
                                        let win = controller.mark(x: x, y: y)
                                        print("mark: ", x, y, win)
                                    }.fixedSize(horizontal: true, vertical: true)
                                    .frame(width: 29, height: 29)
                            }
                        }
                    }
                }
            }
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
