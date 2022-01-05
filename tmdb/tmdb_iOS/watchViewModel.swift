//
//  watchViewModel.swift
//  csci571_hw9
//
//  Created by Kevin Tran on 4/13/21.
//

import SwiftUI
import Combine
import Foundation

struct Item: Identifiable, Equatable, Codable {
    let url: String
    let id: String
    let type: String
    let title: String
}


class watchViewModel: ObservableObject {
    @Published var watchList: [Item]
    @Published var currentItem: Item?
    
    init() {
        let data = UserDefaults.standard.object(forKey: "data") as? [Data] ?? []
        if data.isEmpty {
            self.watchList = [Item]()
            let data = self.watchList.map { try? JSONEncoder().encode($0) }
            UserDefaults.standard.set(data, forKey: "data")
            return
        }
        
        self.watchList = data.map { try! JSONDecoder().decode(Item.self, from: $0) }
    }
    
    func inStorage(item: Item) -> Bool {
        if watchList.contains(where: { $0.id == item.id }) {
            return true
        }
        return false
    }
    
    func add(item: Item) {
        if watchList.contains(where: { $0.id == item.id}) {
            
        } else {
            watchList.append(item)
        }
    }
    
    func remove(item: Item) {
        if let index = watchList.firstIndex(of: item) {
            watchList.remove(at: index)
        }
    }
    /*
    func refresh() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.watchList) {
            UserDefaults.standard.set(encoded, forKey: "data")
        }
    }*/
    
    func refresh() {
        let data = self.watchList.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: "data")
    }
}


