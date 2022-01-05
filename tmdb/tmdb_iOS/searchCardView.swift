//
//  searchCardView.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/12/21.
//

import SwiftUI
import Kingfisher
import SwiftyJSON

struct searchCardView: View {
    var query = Dictionary<String, String>()
    
    init(query: JSON) {
        for (key, obj) in query {
            self.query[key] = obj.stringValue
        }
    }
    
    var body: some View {
        NavigationLink(
            destination: detailView(id: query["id"]!, type: query["media_type"]!, url: query["poster_path"]!, title: query["title"]!)) {
            ZStack {
                KFImage(URL(string: query["backdrop_path"]!))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(15)
                Text(query["media_type"]!+"(" + query["release_year"]! + ")")
                    .foregroundColor(.white)
                    .font(Font.title3.weight(.bold))
                    .textCase(.uppercase)
                    .frame(width: 360, height: 50, alignment: .leading)
                    .padding(.leading, 30)
                    .padding(.bottom, 120)
                Text(query["title"]!)
                    .foregroundColor(.white)
                    .font(Font.title3.weight(.bold))
                    .frame(width: 360, height: 50, alignment: .leading)
                    .padding(.leading, 30)
                    .padding(.top, 120)
                
                ZStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.red)
                        .frame(width: 360, height: 50, alignment: .trailing)
                        .padding(.trailing, 175)
                        .padding(.bottom, 120)
                    Text(query["vote_average"]!)
                        .foregroundColor(.white)
                        .font(Font.title3.weight(.bold))
                        .frame(width: 360, height: 50, alignment: .trailing)
                        .padding(.trailing, 30)
                        .padding(.bottom, 120)
                }
                
            }
        }
    }
}

struct searchCardView_Previews: PreviewProvider {
    static var previews: some View {
        searchCardView(query: [
            "title" : "Avengers: Endgame",
            "id" : "299534",
            "backdrop_path" : "https://image.tmdb.org/t/p/w780/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg",
            "media_type" : "movie",
            "release_year" : "2019",
            "vote_average" : "4.2/5.0"
          ])
    }
}
