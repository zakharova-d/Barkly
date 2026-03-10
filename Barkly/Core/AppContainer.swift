//
//  AppContainer.swift
//  Barkly
//
//  Created by Daria Zakharova on 03.03.2026.
//

import Foundation

@MainActor
final class AppContainer {

    let dogService: DogService
    let favoritesStore: FavoritesStore

    init(
        dogService: DogService = LiveDogService(),
        favoritesStore: FavoritesStore? = nil
    ) {
        self.dogService = dogService

        self.favoritesStore = favoritesStore ?? FavoritesStore(
            persistence: UserDefaultsFavoritesPersistence()
        )
    }
}
