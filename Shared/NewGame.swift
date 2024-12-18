//
//  NewGame.swift
//  Minesweeper
//
//  Created by Paul Ossenbruggen on 6/25/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import SwiftUI

/// Display a view asking for user to input new board siz
struct NewGameView: View {
    @State var controller: NewGameController
    @State var gameController : SweeperController
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .bold()
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)

            Text("# of Mines \(Int(controller.mines))")

            Slider(
                value: $controller.mines,
                in: 1...(controller.size * controller.size),
                step: 1,
                onEditingChanged: finshedControlChange
            )
            .tint(colorizeControl())

            Text("Size \(Int(controller.size))")

            Slider(
                value: $controller.size,
                in: 2...100,
                step: 1,
                onEditingChanged: finshedControlChange
            )

            Button("Start") {
                Task { [gameController] in
                   gameController.state = .playing
                   await gameController.reset()
                }
            }
            .bold()
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)

            Text("Reveal a spot by tapping on cell. Counts give number of mines next to cell. Long press on mine to mark it. Win by marking all the mines")
        }
        .padding(.horizontal, 10)
        .frame(width: 300)
        .padding(.vertical, 10)
        .border(Color.black, width: 2)
        .background(Color.green.opacity(0.8))
    }

    func colorizeControl() -> Color {
        let percent = controller.mines / (controller.size * controller.size)
        return switch percent * 100 {
        case 1..<15: Color.white
        case 15..<20: Color.yellow
        case 20..<30: Color.orange
        case 30...100: Color.red
        default: Color.red
        }
    }

    func finshedControlChange(_ editing: Bool) {
        controller.mines = (controller.mines > controller.size * controller.size)
            ? controller.size * controller.size
            : controller.mines
    }
}

#Preview {
    NewGameView(controller:NewGameController(), gameController: SweeperController(), title:  "Lose")
}

//struct NewGameWin_Previews: PreviewProvider {
//    static var previews: some View {
//        NewGameView(title: "Win")
//    }
//}

