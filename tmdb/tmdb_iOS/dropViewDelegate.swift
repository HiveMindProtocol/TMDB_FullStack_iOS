//
//  dropViewDelegate.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/13/21.
//

import SwiftUI

struct dropViewDelegate: DropDelegate {
    var item: Item
    var itemData: watchViewModel
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        let fromIndex = itemData.watchList.firstIndex { (item) -> Bool in
            return item.id == itemData.currentItem?.id
        } ?? 0
        
        let toIndex = itemData.watchList.firstIndex { (item) -> Bool in
            return item.id == self.item.id
        } ?? 0
        
        if fromIndex != toIndex {
            withAnimation(.default) {
                let fromItem = itemData.watchList[fromIndex]
                itemData.watchList[fromIndex] = itemData.watchList[toIndex]
                itemData.watchList[toIndex] = fromItem
            }
           
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}
