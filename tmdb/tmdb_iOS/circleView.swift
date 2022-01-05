//
//  circleView.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/11/21.
//

import SwiftUI
import Kingfisher

struct circleView: View {
    let url: String
    let name: String
    var body: some View {
        VStack {
            if url == "null" {
                Image("cast_placeholder")
                    .resizable()
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 150)
                Text("")
                    .offset(x: 0, y: -10)
            } else {
                KFImage(URL(string: url))
                    .resizable()
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 150)
                Text(name)
                    .offset(x: 0, y: -10)
            }
            
            
        }
        
    }
}

struct circleView_Previews: PreviewProvider {
    static var previews: some View {
        circleView(url: "https://image.tmdb.org/t/p/w500/86jeYFV40KctQMDQIWhJ5oviNGj.jpg", name: "Emilia Clarke")
    }
}
