//
//  ContentView.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/9/21.
//

import SwiftUI

class toastSettings: ObservableObject {
    @Published var isMarked = false
    @Published var isTitle = ""
}


struct ContentView: View {
    @State private var selection = 1
    @StateObject var settings = toastSettings()

    var body: some View {
        TabView(selection: $selection) {
            searchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }.tag(0)
            homeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }.tag(1)
            watchlistView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("WatchList")
                }.tag(2)
        }.environmentObject(settings)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
