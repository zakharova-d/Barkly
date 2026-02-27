//
//  UserDefaultsFavoritesPersistence.swift
//  Barkly
//
//  Created by Daria Zakharova on 27.02.2026.
//


import Foundation

final class UserDefaultsFavoritesPersistence: FavoritesPersistence {

    private let key = "favorite_urls"

    func load() -> [URL] {
        guard let strings = UserDefaults.standard.array(forKey: key) as? [String] else {
            return []
        }
        return strings.compactMap { URL(string: $0) }
    }

    func save(_ urls: [URL]) {
        let strings = urls.map { $0.absoluteString }
        UserDefaults.standard.set(strings, forKey: key)
    }
}