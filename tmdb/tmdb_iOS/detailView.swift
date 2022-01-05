//
//  detailView.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/10/21.
//

import SwiftUI
import SwiftyJSON

struct detailView: View {
    let id: String
    let type: String
    let url: String
    let title: String
    var fb_link: String = ""
    var t_link: String = ""
    
    @Environment(\.openURL) var openURL
    @State var nm: networkManager = networkManager(choice: 4)
    @State private var isExpanded = false
    @State var isBackground = true
    @EnvironmentObject var wvm: watchViewModel
    @EnvironmentObject var settings: toastSettings


    init(id: String, type: String, url: String, title: String) {
        self.id = id
        self.type = type
        self.url = url
        self.title = title
        self.fb_link = "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fwww.themoviedb.org%2F" + type + "%2F" + id + "&amp;src=sdkpreparse"
        self.t_link = "https://twitter.com/intent/tweet?text=Check%20out%20this%20link%3A%20https%3A%2F%2Fwww.themoviedb.org%2F" + type + "%2F" + id + "%20%23CSCI571USCFilms"
    }

    var body: some View {
        if !isBackground {
            ScrollView {
                VStack {
                    if nm.detail["video"]["data"][0]["key"].rawString()! != "null" {
                        videoView(videoId: String(nm.detail["video"]["data"][0]["key"].rawString()!.suffix(11)))
                    }
                    
                    if self.type == "movie" {
                        Text(nm.detail["detail"]["data"][0]["title"].rawString()!)
                            .font(Font.title.weight(.bold))
                            .frame(width: 360, height: 100, alignment: .leading)
                            .lineLimit(2)
                        Text(nm.detail["detail"]["data"][0]["release_date"].rawString()! +
                        " | " + nm.detail["detail"]["data"][0]["genres"].rawString()! )
                            .lineLimit(2)
                            .frame(width: 360, height: 50, alignment: .leading)
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.red)
                            Text(nm.detail["detail"]["data"][0]["vote_average"].rawString()!)
                        }
                        .frame(width: 360, height: 50, alignment: .leading)
                        
                        VStack {
                            Text(nm.detail["detail"]["data"][0]["overview"].rawString()!)
                                .lineLimit(isExpanded ? nil : 3)
                                .overlay(
                                    GeometryReader { proxy in
                                        Button(action: {
                                            isExpanded.toggle()
                                        }) {
                                            Text(isExpanded ? "Show less" : "Show more..")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomTrailing)
                                        .padding(.top, 20)
                                    }
                                )
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        
                        if nm.detail["cast"]["data"].count != 0 {
                            Text("Cast & Crew")
                                .font(Font.title.weight(.bold))
                                .offset(x: 0, y: 20)
                                .frame(width: 360, height: 50, alignment: .leading)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(0 ..< 10, id:\.self) {
                                        circleView(url: nm.detail["cast"]["data"][$0]["profile_path"].rawString()!, name: nm.detail["cast"]["data"][$0]["name"].rawString()!)
                                    }
                                }
                            }
                            .padding(.trailing, 20)
                            .padding(.leading, 20)
                        }
                        
                        if nm.detail["review"]["data"].count != 0 {
                            Text("Reviews")
                                .font(Font.title.weight(.bold))
                                .frame(width: 360, height: 50, alignment: .leading)
                            ForEach(0 ..< 3, id:\.self) {
                                reviewView(author: nm.detail["review"]["data"][$0]["author"].rawString()!, content: nm.detail["review"]["data"][$0]["content"].rawString()!, created_at: nm.detail["review"]["data"][$0]["created_at"].rawString()!, rating: nm.detail["review"]["data"][$0]["rating"].rawString()!, title: nm.detail["detail"]["data"][0]["title"].rawString()!)
                                    .padding(.trailing, 10)
                                    .padding(.leading, 10)
                            }
                        }
                        if nm.detail["recommend"]["data"].count != 0 {
                            Text("Recommended Movies")
                                .font(Font.title.weight(.bold))
                                .frame(width: 360, height: 50, alignment: .leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 25) {
                                    ForEach(0 ..< nm.detail["recommend"]["data"].count, id:\.self) {
                                        cardView(url: nm.detail["recommend"]["data"][$0]["poster_path"].rawString()!, title: "", date: "", id: nm.detail["recommend"]["data"][$0]["id"].rawString()!, type: "movie")
                                    }
                                }
                            }
                            .padding(.leading, 20)
                            .padding(.bottom, 20)
                            .padding(.trailing, 20)
                        }
                    } else {
                        Text(nm.detail["detail"]["data"][0]["name"].rawString()!)
                            .font(Font.title.weight(.bold))
                            .frame(width: 360, height: 100, alignment: .leading)
                            .lineLimit(2)
                        Text(nm.detail["detail"]["data"][0]["first_air_date"].rawString()! +
                        " | " + nm.detail["detail"]["data"][0]["genres"].rawString()! )
                            .lineLimit(2)
                            .frame(width: 360, height: 50, alignment: .leading)
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.red)
                            Text(nm.detail["detail"]["data"][0]["vote_average"].rawString()!)
                        }
                        .frame(width: 360, height: 50, alignment: .leading)
                        VStack {
                            Text(nm.detail["detail"]["data"][0]["overview"].rawString()!)
                                .lineLimit(isExpanded ? nil : 3)
                                .overlay(
                                    GeometryReader { proxy in
                                        Button(action: {
                                            isExpanded.toggle()
                                        }) {
                                            Text(isExpanded ? "Show less" : "Show more..")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomTrailing)
                                        .padding(.top, 20)
                                    }
                                )
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        
                        if nm.detail["cast"]["data"].count != 0 {
                            Text("Cast & Crew")
                                .font(Font.title.weight(.bold))
                                .offset(x: 0, y: 20)
                                .frame(width: 360, height: 50, alignment: .leading)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(0 ..< 10, id:\.self) {
                                        circleView(url: nm.detail["cast"]["data"][$0]["profile_path"].rawString()!, name: nm.detail["cast"]["data"][$0]["name"].rawString()!)
                                    }
                                }
                            }
                            .padding(.trailing, 20)
                            .padding(.leading, 20)
                        }
                        
                        
                        
                        if nm.detail["review"]["data"].count != 0 {
                            Text("Reviews")
                                .font(Font.title.weight(.bold))
                                .frame(width: 360, height: 50, alignment: .leading)
                            ForEach(0 ..< 3, id:\.self) {
                                reviewView(author: nm.detail["review"]["data"][$0]["author"].rawString()!, content: nm.detail["review"]["data"][$0]["content"].rawString()!, created_at: nm.detail["review"]["data"][$0]["created_at"].rawString()!, rating: nm.detail["review"]["data"][$0]["rating"].rawString()!, title: nm.detail["detail"]["data"][0]["name"].rawString()!)
                                    .padding(.trailing, 10)
                                    .padding(.leading, 10)
                            }
                        }
                        
                        if nm.detail["recommend"]["data"].count != 0 {
                            Text("Recommended TV Shows")
                                .font(Font.title.weight(.bold))
                                .frame(width: 360, height: 50, alignment: .leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 25) {
                                    ForEach(0 ..< nm.detail["recommend"]["data"].count, id:\.self) {
                                        cardView(url: nm.detail["recommend"]["data"][$0]["poster_path"].rawString()!, title: "", date: "", id: nm.detail["recommend"]["data"][$0]["id"].rawString()!, type: "tv")
                                    }
                                }
                            }
                            .padding(.leading, 20)
                            .padding(.bottom, 20)
                            .padding(.trailing, 20)
                        }
                    }
                }
                .onDisappear {
                    self.nm.detail(id: self.id, type: self.type)
                }
                .onAppear {
                    self.nm.detail(id: self.id, type: self.type)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Label("", systemImage: self.wvm.inStorage(item: Item(url: url, id: id, type: type, title: title)) ? "bookmark.fill" : "bookmark")
                            .labelStyle(IconOnlyLabelStyle())
                            .foregroundColor(self.wvm.inStorage(item: Item(url: url, id: id, type: type, title: title)) ? Color.blue : Color.black)
                            .onTapGesture() {
                                if !self.wvm.inStorage(item: Item(url: url, id: id, type: type, title: title)) {
                                    self.nm.detail(id: self.id, type: self.type)
                                    self.wvm.add(item: Item(url: url, id: id, type: type, title: title))
                                    self.wvm.refresh()
                                    settings.isMarked = true
                                    
                                    settings.isTitle = self.title + " was added to Watchlist"
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        settings.isMarked = false
                                    }
                                } else {
                                    self.nm.detail(id: self.id, type: self.type)
                                    self.wvm.remove(item: Item(url: url, id: id, type: type, title: title))
                                    self.wvm.refresh()
                                    settings.isMarked = true
                                    settings.isTitle = self.title + " was removed from Watchlist"
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        settings.isMarked = false
                                    }
                                }
                                
                                self.nm.get(choice: 2, id: id, type: type)
                               
                              
                            }
                        
                        
                        Link(destination: URL(string: self.fb_link)!) {
                            Image("facebook-app-symbol-nav")
                        }
                        Link(destination: URL(string: self.t_link)!) {
                            Image("twitter-nav")
                        }
                    }
                }
            }
            
        } else {
            ProgressView("Fetching Data...")
                .onAppear {
                    self.nm.detail(id: self.id, type: self.type)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isBackground = false
                    }
                }
        }
    }
    
    func add() {
        DispatchQueue.main.async {
            wvm.add(item: Item(url: url, id: id, type: type, title: title))
            wvm.refresh()
            nm.detail(id: id, type: type)
        }
    }
    
}

struct detailView_Previews: PreviewProvider {
    static var previews: some View {
        //detailView(id: "4343", type: "tv")
        //detailView(id: "791373", type: "movie")
        detailView(id: "1399", type: "tv", url: "https://image.tmdb.org/t/p/w500/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg", title: "Game of Thrones")
    }
}
