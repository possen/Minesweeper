//
//  BackgroundView.swift
//  Minesweeper
//
//  Created by Paul Ossenbruggen on 6/25/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var controller: SweeperController
    
    var body: some View {
        ZStack {
            Color.blue
            BoardView()
            switch controller.state {
            case .win:
                NewGameView(title: "Win" )
            case .lose:
                NewGameView(title: "Lose" )
            default:
                Text("")
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
