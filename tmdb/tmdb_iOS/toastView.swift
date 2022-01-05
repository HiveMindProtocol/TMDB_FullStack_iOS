//
//  toastView.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/13/21.
//

import SwiftUI

struct toastView<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    let presenting: () -> Presenting
    let text: Text
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.presenting()
                VStack {
                    self.text
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                }
                //.frame(height: geometry.size.height / 15)
                .frame(width: geometry.size.width / 2, height: geometry.size.height / 15, alignment: .center)
                .background(Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(25)
                .transition(.slide)
                
                
                .opacity(self.isShowing ? 1 : 0)
                .offset(x: 0, y: 275)
                .font(.caption)
                .fixedSize()
                .lineLimit(2)
                
            }
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, text: Text) -> some View {
        toastView(isShowing: isShowing, presenting: { self }, text: text)
    }
}
