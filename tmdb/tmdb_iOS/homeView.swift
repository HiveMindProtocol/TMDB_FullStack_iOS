//
//  homeView.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/9/21.
//

import SwiftUI
import Kingfisher

struct homeView: View {
    @State var toggle = true
    @StateObject var nm = networkManager(choice: 1)
    @State var isBackground = true
    @EnvironmentObject var settings: toastSettings
    
   
    var body: some View {
        if !isBackground {
            NavigationView {
                ScrollView {
                    Text(self.toggle ? "Now Playing" : "Trending")
                        .font(Font.title2.weight(.bold))
                        .frame(width: 360, height: 55, alignment: .leading)
                    HStack {
                       GeometryReader { geometry in
                            imageCarouselView(numImages: 20) {
                                if !toggle {
                                    ForEach(0 ..< self.nm.main["airTV"]["data"].count, id:\.self) {
                                        carouselView(url: self.nm.main["airTV"]["data"][$0]["poster_path"].rawString()!, id: self.nm.main["airTV"]["data"][$0]["id"].rawString()!, type: "tv", width: geometry.size.width, height: geometry.size.height, title: self.nm.main["airTV"]["data"][$0]["title"].rawString()!)
                                    }
                                } else {
                                    ForEach(0 ..< self.nm.main["curMov"]["data"].count, id:\.self) {
                                        carouselView(url: self.nm.main["curMov"]["data"][$0]["poster_path"].rawString()!, id: self.nm.main["curMov"]["data"][$0]["id"].rawString()!, type: "movie", width: geometry.size.width, height: geometry.size.height, title: self.nm.main["curMov"]["data"][$0]["title"].rawString()!)
                                    }
                                }
                            }
                       }
                    }
                    .padding(.top, 130)

                    Text("Top Rated")
                        .font(Font.title2.weight(.bold))
                        .frame(width: 360, height: 25, alignment: .leading)
                        .padding(.bottom, 0)
                        .padding(.top, 150)
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 15) {
                            ForEach(0 ..< self.nm.topRateMov.count, id:\.self) {
                                if !self.toggle {
                                    cardView(url: self.nm.main["topRateTV"]["data"][$0]["poster_path"].rawString()!, title:self.nm.main["topRateTV"]["data"][$0]["name"].rawString()!, date: self.nm.main["topRateTV"]["data"][$0]["first_air_date"].rawString()!, id: self.nm.main["topRateTV"]["data"][$0]["id"].rawString()!, type: "tv")
                                } else {
                                    cardView(url: self.nm.main["topRateMov"]["data"][$0]["poster_path"].rawString()!, title: self.nm.main["topRateMov"]["data"][$0]["title"].rawString()!, date: self.nm.main["topRateMov"]["data"][$0]["release_date"].rawString()!, id: self.nm.main["topRateMov"]["data"][$0]["id"].rawString()!, type: "movie")
                                }
                            }
                        }
                    }
                    .padding(.leading, 5)
                    Text("Popular")
                        .font(Font.title2.weight(.bold))
                        .frame(width: 360, height: 25, alignment: .leading)
                    ScrollView(.horizontal) {
                        HStack(spacing: 15) {
                            ForEach(0 ..< self.nm.popMov.count, id:\.self) {
                                if !self.toggle {
                                    cardView(url: self.nm.main["popTV"]["data"][$0]["poster_path"].rawString()!, title: self.nm.main["popTV"]["data"][$0]["name"].rawString()!, date: self.nm.main["popTV"]["data"][$0]["first_air_date"].rawString()!, id: self.nm.main["popTV"]["data"][$0]["id"].rawString()!, type: "tv")
                                } else {
                                    cardView(url: self.nm.main["popMov"]["data"][$0]["poster_path"].rawString()!, title: self.nm.main["popMov"]["data"][$0]["title"].rawString()!, date: self.nm.main["popMov"]["data"][$0]["release_date"].rawString()!, id: self.nm.main["popMov"]["data"][$0]["id"].rawString()!, type: "movie")
                                }
                            }
                        }
                    }
                    .padding(.leading, 5)
                    Link("Powered by TMDB", destination: URL(string: "https://www.themoviedb.org")!)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding(.top, 100)
                    Text("Developed by Kevin")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                }
                .navigationTitle("USC Films")
                .toolbar {
                    Button(action: {
                        self.toggle = !self.toggle
                        
                    }, label: {
                        Text(self.toggle ? "TV Shows" : "Movies")
                    })
                }
            }

            .toast(isShowing: $settings.isMarked, text: Text(settings.isTitle))
            //.navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            ProgressView("Fetching Data...")
                .onAppear {
                    nm.home()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.isBackground = false
                    }
                }
        }
    }
    
}

struct homeView_Previews: PreviewProvider {
    static var previews: some View {
        homeView()
    }
}

