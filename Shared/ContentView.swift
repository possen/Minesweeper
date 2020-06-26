//
//  ContentView.swift
//  Shared
//
//  Created by Paul Ossenbruggen on 6/23/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var controller: SweeperController
    
    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.all)
            GameView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
