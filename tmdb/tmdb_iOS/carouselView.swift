//
//  carouselView.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/10/21.
//

import SwiftUI
import Kingfisher

struct carouselView: View {
    let url: String
    let id: String
    let type: String
    let width: CGFloat
    let height: CGFloat
    let title: String
    
    var body: some View {
        NavigationLink(destination: detailView(id: id, type: type, url: url, title: title)) {
            ZStack {
                VStack {
                    KFImage(URL(string: url))
                        .resizable()
                        .frame(height: 250)
                        .blur(radius: 5)
                }
                
                KFImage(URL(string: url))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 245)
            }
            .padding(.trailing, 20)
            .padding(.leading, 20)
        }.frame(width: width, height: height)
    }
}
struct carouselView_Previews: PreviewProvider {
    static var previews: some View {
        carouselView(url: "https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg", id: "278", type: "movie", width: 300, height: 300, title: "Shawshank Redemption")
    }
}

