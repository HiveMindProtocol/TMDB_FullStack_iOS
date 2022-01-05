//
//  videoView.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/12/21.
//

import SwiftUI
import youtube_ios_player_helper

struct videoWrapper: UIViewRepresentable {
    var videoId: String
    func makeUIView(context: Context) -> YTPlayerView {
        let ytPlayerView = YTPlayerView()
        ytPlayerView.load(withVideoId: videoId)
        return ytPlayerView
    }
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        //
    }
}

struct videoView: View {
    let videoId: String
    var body: some View {
        VStack {
            videoWrapper(videoId: videoId)
        }
        .frame(width: 360, height: 200, alignment: .leading)
    }
}

struct videoView_Previews: PreviewProvider {
    static var previews: some View {
        videoView(videoId: "https:www.youtube.com/watch?v=jQtP1dD6jQ0")
    }
}
