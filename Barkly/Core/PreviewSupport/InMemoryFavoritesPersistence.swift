//
//  InMemoryFavoritesPersistence.swift
//  Barkly
//
//  Created by Daria Zakharova on 05.03.2026.
//

import Foundation


#if DEBUG
final class InMemoryFavoritesPersistence: FavoritesPersistence {

    private var stored: [URL] = []

    func load() -> [URL] {
        stored
    }

    func save(_ urls: [URL]) {
        stored = urls
    }
}
#endif
