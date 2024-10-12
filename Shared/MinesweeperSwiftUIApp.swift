//
//  MinesweeperSwiftUIApp.swift
//  Shared
//
//  Created by Paul Ossenbruggen on 6/23/20.
//  Copyright © 2020 Paul Ossenbruggen. All rights reserved.
//

import SwiftUI

/// Main app
@main
struct MinesweeperSwiftUIApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(SweeperController())
        }
    }
}
