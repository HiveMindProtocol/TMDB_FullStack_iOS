//
//  watchlistCardView.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/12/21.
//

import SwiftUI
import Kingfisher

struct watchlistCardView: View {
    let url: String
    let id: String
    let type: String
    let title: String
    @EnvironmentObject var wvm: watchViewModel

    var body: some View {
        ZStack {
            NavigationLink(
                destination: detailView(id: id, type: type, url: url, title: title)) {
                VStack {
                    KFImage(URL(string: url))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 170)
                }
            }.contextMenu(ContextMenu(menuItems: {
                Button {
                    self.wvm.remove(item: Item(url: url, id: id, type: type, title: title))
                    self.wvm.refresh()
                } label : {
                    Label("Remove from watchlist", systemImage: "bookmark.fill")
                }
            }))
        }
    }
}

struct watchlistCardView_Previews: PreviewProvider {
    static var previews: some View {
        watchlistCardView(url: "https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg", id: "279", type: "movie", title: "Shawshank Redemption")
    }
}
