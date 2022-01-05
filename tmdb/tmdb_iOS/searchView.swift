//
//  searchView.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/9/21.
//

import SwiftUI



struct searchView: View {
    @State private var query : String = ""
    @StateObject var nm = networkManager(choice: 2, id: "", type: "", query: "")
    @EnvironmentObject var settings: toastSettings
    let debouncer = Debouncer(delay: 0.5)

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    SearchBar(text: $query, placeholder: "Search Movies, TVs...", onTextChanged: search)
                }
                ScrollView (.vertical, showsIndicators: false) {
                    VStack {
                        if self.nm.search.count > 1 {
                            ForEach(0 ..< self.nm.search.count, id:\.self) {
                                searchCardView(query: self.nm.search[$0])
                            }
                        } else if self.nm.search.count < 1 && query.count > 2{
                            Text("No Results")
                                .foregroundColor(.gray)
                                .font(.title2)
                        }
                    }
                }
                .navigationBarTitle("Search")
            }
        }
        .toast(isShowing: $settings.isMarked, text: Text(settings.isTitle))
    }
    
    
    func search(for query: String) {
        if query.count > 2 {
            debouncer.run(action: {
                self.nm.search(query: query)
            })
        } else {
            self.nm.search = "{}"
        }
    }
}

struct searchView_Previews: PreviewProvider {
    static var previews: some View {
        searchView()
    }
}
