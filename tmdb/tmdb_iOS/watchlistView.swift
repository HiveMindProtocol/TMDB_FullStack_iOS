//
//  watchlistView.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/9/21.
//

import SwiftUI

struct watchlistView: View {
    let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
    @State var keys: [Dictionary<String, String>] = [Dictionary<String, String>]()
    @EnvironmentObject var wvm: watchViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if self.wvm.watchList.isEmpty {
                    Text("Watchlist is empty")
                        .foregroundColor(.gray)
                        .font(.title)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        Text("Watchlist")
                            .font(Font.title.weight(.bold))
                            .frame(width: 360, height: 25, alignment: .leading)
                            .padding(.bottom, 0)
                            .padding(.top, 25)
                        LazyVGrid(columns: columns, content: {
                            ForEach(self.wvm.watchList) { item in
                                watchlistCardView(url: item.url, id: item.id, type: item.type, title: item.title)
                                    .onDrag({
                                        wvm.currentItem = item
                                        return NSItemProvider(contentsOf: URL(string: "\(item.id)")!)!
                                    })
                                
                                    .onDrop(of: [.url], delegate: dropViewDelegate(item: item, itemData: wvm))
                            }
                        })
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                }
                
            }
        }
        .environmentObject(wvm)
        .onAppear {
            self.wvm.refresh()
        }
        .onDisappear {
            self.wvm.refresh()
        }
    }
}

struct watchlistView_Previews: PreviewProvider {
    static var previews: some View {
        watchlistView()
    }
}
/*
 .onAppear {
     if ((defaults.object(forKey: "local") as? [Dictionary<String, String>] != nil) && (!((defaults.object(forKey: "local") as! [Dictionary<String, String>]).isEmpty ))) {
         self.keys = defaults.object(forKey: "local") as! [Dictionary<String, String>]
     }
     debugPrint(self.keys)

 }
 .onDisappear {
     if ((defaults.object(forKey: "local") as? [Dictionary<String, String>] != nil) && (!((defaults.object(forKey: "local") as! [Dictionary<String, String>]).isEmpty ))) {
         self.keys = defaults.object(forKey: "local") as! [Dictionary<String, String>]
         debugPrint("JHERHEHREHRHERE")
     }
     debugPrint(self.keys)
 }
 */
