//
//  cardView.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/10/21.
//

import SwiftUI
import Kingfisher

struct cardView: View {
    let url: String
    let title: String
    let date: String
    let id: String
    let type: String
    let defaults = UserDefaults.standard
    let twitter_link = "https://twitter.com/intent/tweet?text=Check%20out%20this%20link%3A%20https%3A%2F%2Fwww.themoviedb.org%2F"
    @EnvironmentObject var wvm: watchViewModel
    @EnvironmentObject var settings: toastSettings
    
    var body: some View {
        ZStack {
            NavigationLink(
                destination: detailView(id: id, type: type, url: url, title: title)) {
                VStack {
                    if title == "" {
                        KFImage(URL(string: url))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                            .cornerRadius(15)
                    } else {
                        KFImage(URL(string: url))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                            .cornerRadius(15)
                        Text(title)
                            .font(Font.caption.weight(.bold))
                            .foregroundColor(.black)
                            .frame(width: 120, height: 50, alignment: .center)
                            .multilineTextAlignment(.center)
                        Text("(" + date + ")")
                            .font(.caption)
                            .offset(x: 0, y: -4)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .contextMenu(ContextMenu(menuItems: {
            Button {
                if !self.wvm.inStorage(item: Item(url: url, id: id, type: type, title: title)) {
                    self.wvm.add(item: Item(url: url, id: id, type: type, title: title))
                    self.wvm.refresh()
                    settings.isMarked = true
                    settings.isTitle = self.title + " was added to Watchlist"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        settings.isMarked = false
                    }
                } else {
                    self.wvm.remove(item: Item(url: url, id: id, type: type, title: title))
                    self.wvm.refresh()
                    settings.isMarked = true
                    settings.isTitle = self.title + " was removed from Watchlist"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        settings.isMarked = false
                    }
                }
            } label : {
                if !self.wvm.inStorage(item: Item(url: url, id: id, type: type, title: title)) {
                    Label("Add to watchList", systemImage: "bookmark")
                } else {
                    Label("Remove from watchList", systemImage: "bookmark.fill")

                }
            }
                
            Link(destination: URL(string: "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fwww.themoviedb.org%2F" + self.type + "%2F" + self.id + "&amp;src=sdkpreparse")!) {
                HStack {
                    Text("Share on Facebook")
                    Image("facebook-app-symbol")
                }
            }
                
            Link(destination: URL(string: self.twitter_link + self.type + "%2F" + self.id + "%20%23CSCI571USCFilms")!) {
                HStack {
                    Text("Share on Twitter")
                    Image("twitter")
                }
            }
            
        }))
        
    }
}

struct cardView_Previews: PreviewProvider {
    static var previews: some View {
        cardView(url: "https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg", title: "The Shawshank Redemption", date: "1994", id: "279", type: "movie")
    }
}
