//
//  BarklyApp.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.02.2026.
//

import SwiftUI

@main
struct BarklyApp: App {
    private let dogService: DogService
    @StateObject private var favoritesStore: FavoritesStore

    init() {
        self.dogService = LiveDogService()

        let persistence: FavoritesPersistence = UserDefaultsFavoritesPersistence()
        _favoritesStore = StateObject(wrappedValue: FavoritesStore(persistence: persistence))
    }

    var body: some Scene {
        WindowGroup {
            RootTabView(service: dogService)
                .environmentObject(favoritesStore)
        }
    }
}
