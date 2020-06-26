//
//  NewGame.swift
//  Minesweeper
//
//  Created by Paul Ossenbruggen on 6/25/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import SwiftUI

struct NewGameView: View {
    @EnvironmentObject var controller: SweeperController
    let title: String

    var body: some View {
        VStack {
            Text(title).bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text("# of Mines \(Int(controller.difficulty))")
            Slider(value: $controller.difficulty, in: 1...1000, step: 1)
            Text("Size \(Int(controller.size))")
            Slider(value: $controller.size, in: 1...100, step: 1)
        }.padding(.all, 50).border(Color.black, width: 2).background(Color.green.opacity(0.6))
        .onTapGesture {
            controller.reset()
        }
    }
}

