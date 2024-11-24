//
//  BackgroundView.swift
//  Minesweeper
//
//  Created by Paul Ossenbruggen on 6/25/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @State var controller: SweeperController

    var body: some View {
        ZStack(alignment: .top) {
            Color.green
            GameBoardView()
            switch controller.state {
            case .win:
                NewGameView(controller: NewGameController(), gameController: controller, title: "Win!")
            case .lose:
                NewGameView(controller: NewGameController(), gameController: controller, title: "Lose!")
            default:
                Text("")
            }
        }
    }
}

#Preview {
    NewGameView(controller: NewGameController(), gameController: SweeperController(), title: "Win")
}

