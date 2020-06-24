//
//  ContentView.swift
//  Shared
//
//  Created by Paul Ossenbruggen on 6/23/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var controller = SweeperController()
    
    var body: some View {
        BoardView(controller: controller)
    }
}

struct BoardView: View {
    @ObservedObject var controller: SweeperController
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack(spacing: 0) {
                ForEach(0..<controller.board.dimensions.1) {y in
                    HStack(spacing: 0) {
                        ForEach(0..<controller.board.dimensions.0) { x in
                            Text(LocalizedStringKey(convert(controller.board.piece(x: x, y: y)!).rawValue))
                                .font(.title)
                                .onTapGesture {
                                    controller.reveal(x: x, y: y)
                                    print("reveal: ", x, y)
                                }.onLongPressGesture {
                                    controller.mark(x: x, y: y)
                                    print("mark: ", x, y)
                                }.fixedSize(horizontal: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                .frame(width: 29, height: 29)

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
