//
//  csci571_hw9App.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/9/21.
//

import SwiftUI

@main
struct csci571_hw9App: App {
    @StateObject var wvm = watchViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(wvm)
        }
    }
}
