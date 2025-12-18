//
//  WishlistStorage.swift
//  SantaCallSimulator
//
//  Created by b on 12.12.2025.
//

import Foundation

final class WishlistStorage {
    static let shared = WishlistStorage()
    private init() {
        load()
    }
    
    private let key = "WishlistItems"
    private(set) var items: [String] = []
    
    func add(item: String) {
        items.append(item)
        save()
    }
    
    func remove(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            items.remove(at: index)
        }
        save()
    }
    
    func removeAll() {
        items.removeAll()
        save()
    }
    
    private func save() {
        UserDefaults.standard.set(items, forKey: key)
    }
    
    private func load() {
        if let saved = UserDefaults.standard.stringArray(forKey: key) {
            items = saved
        }
    }
}

