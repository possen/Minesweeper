//
//  ContentView.swift
//  Shared
//
//  Created by Paul Ossenbruggen on 6/23/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var controller: SweeperController

    var body: some View {
        NavigationStack {
            NavigationLink("New Game") {
                NewGameView(controller: NewGameController(), gameController: controller, title: "New")
            }
            ZStack {
                Color.green.edgesIgnoringSafeArea(.all)
                GameView(controller: controller)
            }
        }
    }
}

#Preview {
    ContentView(controller: SweeperController())
}
