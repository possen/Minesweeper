//
//  Minesweeper_AppClipApp.swift
//  Minesweeper-AppClip
//
//  Created by Paul Ossenbruggen on 6/30/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import SwiftUI

@main
struct Minesweeper_AppClipApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(SweeperController())
        }
    }
}
